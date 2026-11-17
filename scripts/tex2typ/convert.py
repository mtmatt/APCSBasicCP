"""Convert the LaTeX book under Files/ into Typst files under chapters/.

swift-shifter (https://github.com/mtmatt/swift-shifter) reads the LaTeX and
writes the first draft. This script prepares its input and finishes its output.

Before: the book's own commands and environments (\\problem, tip, captioned
listings, ...) become marker paragraphs, which swift-shifter keeps as text, and
markers note where each source file starts and ends.

After: the draft is split back into one .typ file per .tex file, the markers
become the template's components, mitex formulas become native Typst math
(through pandoc), sample I/O tables become `#sample-io`, and images get their
paths and widths back.

Usage:
    python3 scripts/tex2typ/convert.py --swift-shifter PATH \\
        [--source Files] [--out chapters]
"""

import argparse
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]

# (source folder, chapter file, output folder)
CHAPTERS = [
    ("01CodingStyle", "CodingStyle", "01-coding-style"),
    ("02BasicSkills", "BasicSkills", "02-basic-skills"),
    ("03Techniques", "Techniques", "03-techniques"),
    (
        "04BasicDataStructures",
        "BasicDataStructures",
        "04-basic-data-structures",
    ),
    ("05Tree", "Tree", "05-tree"),
    ("06GraphBasic", "GraphBasic", "06-graph-basic"),
    ("07Mathematic", "Mathematic", "07-mathematics"),
    ("08AdvancedDS", "AdvancedDS", "08-advanced-ds"),
    ("09DynamicPrograming", "DynamicPrograming", "09-dynamic-programming"),
    ("10Geometry", "Geometry", "10-geometry"),
    ("11AdvancedTechniques", "AdvancedTechniques", "11-advanced-techniques"),
    ("12MoreProblems", "MoreProblems", "12-more-problems"),
    ("13Strings", "Strings", "13-strings"),
]

# (source file under Files/, output file under chapters/)
STANDALONE = [
    ("-Preface", "preface"),
    ("-Thanks", "thanks"),
    ("Reference", "reference"),
]

# Leaf names the generic rule gets wrong.
LEAF_NAMES = {
    "AD-2DSeg": "2d-seg",
    "AD-DinamicTree": "dynamic-tree",
}

# Environments that become the template component of the same name.
ENVIRONMENTS = ("tip", "quoting", "theorem", "proof")

# Starts a marker paragraph; text the book itself never contains.
MARK = "ZZMARK"


def leaf_name(stem):
    """`T-AllLongestPath` -> `all-longest-path`."""
    if stem in LEAF_NAMES:
        return LEAF_NAMES[stem]
    name = stem.split("-", 1)[1] if "-" in stem else stem
    name = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "-", name)
    name = re.sub(r"(?<=[A-Z])(?=[A-Z][a-z])", "-", name)
    return name.lower()


@dataclass
class Chapter:
    title: str
    label: str | None
    author: str | None
    # (source stem, enabled)
    inputs: list[tuple[str, bool]] = field(default_factory=list)


def parse_chapter(tex):
    """Read a chapter file: its title, label, author and the files it inputs."""
    title = re.search(r"\\begin\{chapter\}\{([^}]*)\}", tex)
    if not title:
        raise ValueError("chapter file has no \\begin{chapter}{...}")
    label = re.search(r"\\label\{([^}]*)\}", tex)
    author = re.search(r"^\s*\\author\{([^}]*)\}", tex, re.M)
    inputs = [
        (m.group(2), not m.group(1))
        for m in re.finditer(r"^\s*(%\s*)?\\input\{([^}]*)\}", tex, re.M)
    ]
    return Chapter(
        title.group(1),
        label.group(1) if label else None,
        author.group(1) if author else None,
        inputs,
    )


def marker(*words):
    """A marker paragraph, which swift-shifter keeps as a line of text."""
    return f"\n\n{MARK} {' '.join(words)}\n\n"


def split_options(options):
    """Split `key=value` options at top-level commas."""
    parts, depth, current = [], 0, ""
    for ch in options:
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(current)
            current = ""
        else:
            current += ch
    parts.append(current)
    result = {}
    for part in parts:
        key, _, value = part.partition("=")
        value = value.strip()
        if value.startswith("{") and value.endswith("}"):
            value = value[1:-1]
        result[key.strip()] = value
    return result


# A sample I/O row written as two `\parbox`es of `\tt` lines.
PARBOX_ROW = re.compile(
    r"\\parbox\[t\]\{[^}]*\}[^\n]*\n\s*\{\s*\\tt\b(.*?)\}\s*&\s*"
    r"\\parbox\[t\]\{[^}]*\}[^\n]*\n\s*\{\s*\\tt\b(.*?)\}\s*\\\\",
    re.S,
)

# One-off fixes for source swift-shifter or pandoc can't read.
FIXUPS = {
    r"$\mod$": r"$\operatorname{mod}$",
}


def verb(text):
    """`text` as `\\verb`, delimited by a character it doesn't contain."""
    delimiter = next((d for d in "|!+=" if d not in text), None)
    if delimiter is None:
        raise ValueError(f"no \\verb delimiter for: {text}")
    return f"\\verb{delimiter}{text}{delimiter}"


def parbox_rows(m):
    """Rewrite a `\\parbox` sample row as one `\\verb` row per line."""

    def cell_lines(body):
        body = re.sub(r"%[^\n]*", "", body)
        body = re.sub(r"\\([_#$%&{}])", r"\1", body)
        # A line break inside a line is a space, as LaTeX sets it.
        lines = body.split("\\\\")
        return [" ".join(line.split()) for line in lines if line.strip()]

    inputs, outputs = cell_lines(m.group(1)), cell_lines(m.group(2))
    rows = []
    for i in range(max(len(inputs), len(outputs))):
        cells = [verb(c[i]) if i < len(c) else "" for c in (inputs, outputs)]
        rows.append(f"{cells[0]} & {cells[1]} \\\\")
    return "\n".join(rows)


def prepare(tex):
    """Rewrite a leaf file's LaTeX so its structure survives swift-shifter."""
    tex = tex.replace("../Images/", "Files/Images/")
    for old, new in FIXUPS.items():
        tex = tex.replace(old, new)
    tex = PARBOX_ROW.sub(parbox_rows, tex)
    # The Strings chapter sets each listing's caption just before it; the
    # listing's own options keep their place after the caption.
    tex = re.sub(
        r"\\lstset\{caption=(\{[^}]*\})\}\s*"
        r"\\begin\{lstlisting\}(?:\[([^\]]*)\])?",
        lambda m: "\\begin{lstlisting}[caption="
        + m.group(1)
        + (f",{m.group(2)}" if m.group(2) else "")
        + "]",
        tex,
    )
    tex = re.sub(
        r"^[ \t]*\\(problem|example)\b[ \t]*(.*)$",
        lambda m: marker(m.group(1), m.group(2)),
        tex,
        flags=re.M,
    )
    names = "|".join(ENVIRONMENTS)
    tex = re.sub(
        rf"\\begin\{{({names})\}}", lambda m: marker("begin", m.group(1)), tex
    )
    tex = re.sub(rf"\\end\{{(?:{names})\}}", marker("end"), tex)

    def listing(m):
        options = split_options(m.group(1) or "")
        caption = options.get("caption")
        begin = "\\begin{lstlisting}[language=C++]"
        return marker("listing", caption) + begin if caption else begin

    return re.sub(r"\\begin\{lstlisting\}(?:\[([^\]]*)\])?", listing, tex)


# --- Typst strings -----------------------------------------------------------


def typst_unescape(s):
    """The text a Typst string literal's body (no quotes) stands for."""

    def unescape(m):
        esc = m.group(1)
        if esc.startswith("u{"):
            return chr(int(esc[2:-1], 16))
        return {"n": "\n", "r": "\r", "t": "\t"}.get(esc, esc)

    return re.sub(r"\\(u\{[0-9a-fA-F]+\}|.)", unescape, s, flags=re.S)


def typst_string(s):
    """`s` as a Typst string literal."""
    s = s.replace("\\", "\\\\").replace('"', '\\"')
    return '"' + s.replace("\n", "\\n").replace("\t", "\\t") + '"'


# --- Math --------------------------------------------------------------------

MITEX = re.compile(r'#(mi|mitex)\((?:/\*f\d+\*/)?"((?:[^"\\]|\\.)*)"\)')

DISPLAY_ENVIRONMENTS = ("align", "align*", "equation", "equation*", "gather")


def cases_columns(m):
    """Give every `cases` row a second column.

    pandoc only reads `cases` as such when each row has one; otherwise it
    writes a lone brace before the rows.
    """
    rows = re.split(r"\\\\", m.group(1))
    rows = [
        row if "&" in row or not row.strip() else row.rstrip() + " &"
        for row in rows
    ]
    return "\\begin{cases}" + "\\\\".join(rows) + "\\end{cases}"


def math_source(tex, display):
    """The LaTeX pandoc reads one formula from."""
    tex = re.sub(
        r"\\begin\{cases\}(.*?)\\end\{cases\}",
        cases_columns,
        tex.strip(),
        flags=re.S,
    )
    if not display:
        return f"${tex}$"
    env = re.match(r"\\begin\{([^}]*)\}", tex)
    if env and env.group(1) in DISPLAY_ENVIRONMENTS:
        return tex
    return f"\\[{tex}\\]"


def pandoc_math(formulas, pandoc="pandoc"):
    """Convert (tex, display) pairs to Typst math, all in one pandoc run."""
    if not formulas:
        return []
    source = "\n\n".join(
        f"ZZMATH{i}\n\n{math_source(tex, display)}"
        for i, (tex, display) in enumerate(formulas)
    )
    out = subprocess.run(
        [pandoc, "-f", "latex", "-t", "typst", "--wrap=none"],
        input=source,
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    parts = re.split(r"^ZZMATH(\d+)\s*$", out, flags=re.M)
    result = [None] * len(formulas)
    for index, body in zip(parts[1::2], parts[2::2]):
        result[int(index)] = body.strip()
    return result


# CJK symbols and punctuation, unified ideographs, fullwidth forms.
CJK = r"[\u3000-\u303f\u4e00-\u9fff\uff00-\uffef]"
STRING = r'"(?:[^"\\]|\\.)*"'

# pandoc writes arrow accents as `accent(body, ⃗)`; Typst has names for them.
ACCENTS = {"⃗": "arrow", "⃡": "arrow.l.r"}


def matching_paren(text, open_index):
    """Index of the `)` closing the `(` at `open_index`, or None."""
    depth = 0
    for i in range(open_index, len(text)):
        depth += {"(": 1, ")": -1}.get(text[i], 0)
        if depth == 0:
            return i
    return None


def accents(typ):
    """`accent(body, ⃗)` -> `arrow(body)`, for the accents Typst names.

    The body may hold parentheses of its own (`accent(O P_(i + 1), ⃗)`).
    Other accents, and a call left unclosed, stay as written.
    """
    out, done = [], 0
    while (start := typ.find("accent(", done)) != -1:
        open_paren = start + len("accent")
        close = matching_paren(typ, open_paren)
        if close is None:
            break
        body, _, mark = typ[open_paren + 1 : close].rpartition(", ")
        out.append(typ[done:start])
        if mark in ACCENTS:
            out.append(f"{ACCENTS[mark]}({body})")
        else:
            out.append(typ[start : close + 1])
        done = close + 1
    return "".join(out) + typ[done:]


# Escapes pandoc writes that are plain text in Typst math.
NEEDLESS_ESCAPES = set("()[]|")


def unescape_delimiters(typ):
    """Drop pandoc's escapes on delimiters where Typst doesn't need them.

    pandoc escapes every parenthesis, bracket, bar and comma (`f \\( n \\)`).
    Those are plain text in Typst math, except a comma inside a function
    call's parentheses, which separates its arguments; that one stays
    escaped. String literals are copied as they are.
    """
    out, i = [], 0
    # One entry per open parenthesis or bracket: whether it opens a call.
    paren_is_call = []
    while i < len(typ):
        ch = typ[i]
        if ch == '"':
            end = i + re.match(STRING, typ[i:]).end()
            out.append(typ[i:end])
            i = end
            continue
        if ch == "\\":
            escaped = typ[i + 1 : i + 2]
            if escaped in ("(", "["):
                paren_is_call.append(False)
            elif escaped in (")", "]") and paren_is_call:
                paren_is_call.pop()
            in_call = any(paren_is_call)
            if escaped in NEEDLESS_ESCAPES or (escaped == "," and not in_call):
                out.append(escaped)
            else:
                out.append(typ[i : i + 2])
            i += 2
            continue
        if ch == "(":
            # `f(` calls f; `_(`, `2(` and ` (` only group.
            before = out[-1][-1] if out else ""
            paren_is_call.append(before.isascii() and before.isalpha())
        elif ch == ")" and paren_is_call:
            paren_is_call.pop()
        out.append(ch)
        i += 1
    return "".join(out)


def outside_strings(typ, rewrite):
    """Apply `rewrite` to the parts of `typ` outside string literals."""
    parts = re.split(f"({STRING})", typ)
    parts[::2] = [rewrite(part) for part in parts[::2]]
    return "".join(parts)


def tidy_spacing(typ):
    """Undo pandoc's spacing in formula text (no string literals)."""
    # The spaces inside delimiters: `( n )`, `[ i ]`, `| v |`.
    typ = re.sub(r"([(\[]) ", r"\1", typ)
    typ = re.sub(r" ([)\],])", r"\1", typ)
    typ = re.sub(r"\| ([^|]+) \|", r"|\1|", typ)
    # `\pmod{m}` comes out as `med (mod med m)`.
    typ = typ.replace("med (mod med ", "quad (mod ")
    # Next to CJK text pandoc puts a space of no width.
    typ = re.sub(r" ?#h\(0em\) ?", " ", typ)
    # CJK text comes one character at a time; make it one string.
    return re.sub(
        rf"{CJK}(?: {CJK})*",
        lambda m: '"' + m.group(0).replace(" ", "") + '"',
        typ,
    )


def tidy_math(typ):
    """Make pandoc's Typst math read as a person would write it."""
    typ = unescape_delimiters(typ)
    typ = accents(typ)
    # `\text{dp}` comes out as `upright("dp")`; quoted text is upright anyway.
    typ = re.sub(rf"upright\(({STRING})\)", r"\1", typ)
    return outside_strings(typ, tidy_spacing)


def failing_math(formulas, typst="typst"):
    """Indexes of the formulas Typst can't compile."""
    # One formula after another, with the formula each line belongs to.
    lines, owner = [], []
    for index, typ in enumerate(formulas):
        for line in (typ or "$$").splitlines():
            lines.append(line)
            owner.append(index)
        lines.append("")
        owner.append(None)
    with tempfile.TemporaryDirectory() as tmp:
        source = Path(tmp) / "math.typ"
        source.write_text("\n".join(lines), encoding="utf-8")
        result = subprocess.run(
            [typst, "compile", source, Path(tmp) / "math.pdf"],
            capture_output=True,
            text=True,
        )
    failing = set()
    for line in re.findall(r"math\.typ:(\d+):", result.stderr):
        if owner[int(line) - 1] is not None:
            failing.add(owner[int(line) - 1])
    if result.returncode and not failing:
        raise RuntimeError(f"typst failed on the formulas:\n{result.stderr}")
    return failing


def convert_math(text, pandoc="pandoc", typst="typst"):
    """Replace mitex calls with native Typst math. Returns (text, failures)."""
    calls = list(MITEX.finditer(text))
    formulas = [
        (typst_unescape(m.group(2)), m.group(1) == "mitex") for m in calls
    ]
    converted = pandoc_math(formulas, pandoc)
    # Text pandoc couldn't read as math comes back as text, not `$...$`.
    converted = [t if t and t.startswith("$") else None for t in converted]
    # Each formula is tried as tidied, then as pandoc wrote it, then given up
    # (left as mitex, and reported). Typst reports only the first errors it
    # finds, so check again until it accepts every formula left.
    chosen = [tidy_math(t) if t else None for t in converted]
    while bad := failing_math(chosen, typst):
        for i in bad:
            if chosen[i] is None:
                # A given-up formula compiles as `$$`; its neighbour broke it.
                tex = formulas[i][0]
                raise RuntimeError(f"typst blames dropped formula: {tex!r}")
            if chosen[i] != converted[i]:
                chosen[i] = converted[i]
            else:
                chosen[i] = None
    failures = []
    pieces, last = [], 0
    for m, (tex, _), typ in zip(calls, formulas, chosen):
        pieces.append(text[last : m.start()])
        if typ is None:
            failures.append(tex)
            pieces.append(m.group(0))
        else:
            pieces.append(typ)
        last = m.end()
    pieces.append(text[last:])
    return "".join(pieces), failures


# --- Draft structure ---------------------------------------------------------


def split_draft(draft):
    """Split swift-shifter's draft at the file markers: {output path: text}.

    Raises ValueError where the markers don't pair up, which would otherwise
    lose a file's text.
    """
    files, current, lines = {}, None, []
    for line in draft.splitlines():
        m = re.fullmatch(rf"\s*{MARK} (file|endfile)(?: (\S+))?\s*", line)
        if not m:
            if current is not None:
                lines.append(line)
            continue
        if m.group(1) == "file":
            if current is not None:
                raise ValueError(f"{current} has no end marker")
            # swift-shifter escapes the slash as markup: `05-tree\/diameter`.
            current, lines = m.group(2).replace("\\", ""), []
        else:
            if current is None:
                raise ValueError("end marker outside a file")
            files[current] = "\n".join(lines).strip("\n") + "\n"
            current = None
    if current is not None:
        raise ValueError(f"{current} has no end marker")
    return files


def finish_markers(text):
    """Turn the marker paragraphs in a file into template components."""
    out = []
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        m = re.fullmatch(rf"(\s*){MARK} (\w+)(?: (.*))?", line)
        if not m:
            out.append(line)
            i += 1
            continue
        indent, kind, rest = m.group(1), m.group(2), (m.group(3) or "").strip()
        if kind in ("problem", "example"):
            out.append(f"{indent}#{kind}[{rest}]")
        elif kind == "begin":
            out.append(f"{indent}#{rest}[")
        elif kind == "end":
            out.append(f"{indent}]")
        elif kind == "listing":
            i = wrap_listing(lines, i, indent, rest, out)
            continue
        else:
            raise ValueError(f"unknown marker: {line}")
        i += 1
    return "\n".join(out) + "\n"


def wrap_listing(lines, i, indent, caption, out):
    """Wrap the code block after the listing marker at `lines[i]`.

    Appends the `#listing` call to `out` and returns the index of the line
    after the code block.
    """
    j = i + 1
    while j < len(lines) and not lines[j].strip():
        j += 1
    fence = j < len(lines) and re.fullmatch(r"\s*(`{3,})\w*\s*", lines[j])
    if not fence:
        raise ValueError(f"listing marker without code after it: {caption}")
    closing = rf"\s*{fence.group(1)}\s*"
    end = j + 1
    while end < len(lines) and not re.fullmatch(closing, lines[end]):
        end += 1
    if end == len(lines):
        raise ValueError(f"unclosed code block in listing: {caption}")
    out.append(f"{indent}#listing([{caption}])[")
    out.extend(lines[j : end + 1])
    out.append(f"{indent}]")
    return end + 1


IMAGE = re.compile(r'image\("[^"]*?-images/\d+-([^"/]+)"')


def image_widths(files):
    """{image file name: Typst width} from the LaTeX sources."""
    widths = {}
    for path in files:
        tex = path.read_text(encoding="utf-8")
        for m in re.finditer(
            r"\\includegraphics(?:\[([^\]]*)\])?\{[^}]*?([^/}]+)\}", tex
        ):
            width = split_options(m.group(1) or "").get("width", "")
            scale = re.fullmatch(r"([\d.]*)\\textwidth", width)
            if scale:
                percent = round(float(scale.group(1) or 1) * 100)
                widths[m.group(2)] = f"{percent}%"
    return widths


def finish_images(text, widths):
    """Point images at the LaTeX book's files, at the widths it gave them."""

    def image(m):
        name = m.group(1)
        width = f", width: {widths[name]}" if name in widths else ""
        return f'image("/Files/Images/{name}"{width}'

    return IMAGE.sub(image, text)


TABLE = re.compile(r"^(\s*)#table\(\n(.*?)\n\1\)", re.S | re.M)
RAW = r'#raw\("((?:[^"\\]|\\.)*)"\)'
# An empty cell, or raw lines. Several in one cell are lines the source didn't
# end with `\\`.
RAW_CELL = re.compile(rf'\[((?:{RAW}(?: (?={RAW}))?)*)\]')
TITLES = re.compile(
    r"(?:table\.header\()?\[([^\]]*輸入[^\]]*)\], \[([^\]]*輸出[^\]]*)\]\)?,?"
)


@dataclass
class Sample:
    input_title: str
    output_title: str
    input_lines: list[str] = field(default_factory=list)
    output_lines: list[str] = field(default_factory=list)

    def call(self, indent):
        """This sample as a `#sample-io` call."""

        def text(lines):
            # Trailing empty cells pad the shorter column.
            return typst_string("\n".join(lines).rstrip("\n"))

        inner = indent + "  "
        return (
            f"{indent}#sample-io(\n"
            f"{inner}{text(self.input_lines)},\n"
            f"{inner}{text(self.output_lines)},\n"
            f"{inner}input-title: [{self.input_title}],\n"
            f"{inner}output-title: [{self.output_title}],\n"
            f"{indent})"
        )


def sample_io(m):
    """A two-column table of samples as one `#sample-io` per sample.

    Tables holding several samples have a title row (`[範例輸入 2], [範例輸出
    2]`) before each sample after the first. Any other cell than a raw line
    or an empty one leaves the table as it is.
    """
    indent, body = m.group(1), m.group(2)
    rows = [line.strip() for line in body.splitlines()]
    # swift-shifter writes `columns:` and `align:` first, then the header.
    settings, cell_rows = rows[:2], rows[2:]
    if "columns: 2," not in settings or not cell_rows:
        return m.group(0)
    if not TITLES.fullmatch(cell_rows[0]):
        return m.group(0)
    samples = []
    for row in cell_rows:
        titles = TITLES.fullmatch(row)
        if titles:
            samples.append(Sample(*titles.groups()))
            continue
        cells = [c.group(1) for c in RAW_CELL.finditer(row)]
        if len(cells) != 2 or RAW_CELL.sub("", row).replace(",", "").strip():
            return m.group(0)
        sample = samples[-1]
        columns = (sample.input_lines, sample.output_lines)
        for lines, cell in zip(columns, cells):
            lines.extend(typst_unescape(raw) for raw in re.findall(RAW, cell))
            if not cell:
                lines.append("")
    return "\n".join(sample.call(indent) for sample in samples)


def finish_tables(text):
    """Turn the sample I/O tables in `text` into `#sample-io` calls."""
    return TABLE.sub(sample_io, text)


def unnumbered_headings(text):
    """Front and back matter: `= X` -> an unnumbered chapter heading."""
    return re.sub(
        r"^= (.*)$", r"#heading(numbering: none)[\1]", text, flags=re.M
    )


def finish(text, widths):
    """Turn one file's part of the draft into its final Typst source."""
    return finish_tables(finish_images(finish_markers(text), widths))


# --- Driver ------------------------------------------------------------------


def chapter_file(chapter):
    """A chapter's `ch.typ`: its heading and the files it includes."""
    lines = ['#import "../../template.typ": *', ""]
    if chapter.author:
        lines += [f'#set-author("{chapter.author}")', ""]
    label = f" <{chapter.label}>" if chapter.label else ""
    lines += [f"= {chapter.title}{label}", ""]
    for stem, enabled in chapter.inputs:
        include = f'#include "{leaf_name(stem)}.typ"'
        lines.append(include if enabled else f"// {include}")
    return "\n".join(lines) + "\n"


def build_driver(work):
    """Write the LaTeX document swift-shifter reads; return the chapters."""
    files = work / "Files"
    body, chapters = [], {}
    for stem, out in STANDALONE:
        path = files / f"{stem}.tex"
        path.write_text(prepare(path.read_text("utf-8")), "utf-8")
        body += [
            marker("file", out),
            f"\\input{{Files/{stem}}}",
            marker("endfile"),
        ]
    for src, stem, out in CHAPTERS:
        source = files / src / f"{stem}.tex"
        chapter = parse_chapter(source.read_text("utf-8"))
        chapters[out] = chapter
        for leaf, _ in chapter.inputs:
            path = files / src / f"{leaf}.tex"
            path.write_text(prepare(path.read_text("utf-8")), "utf-8")
            body += [
                marker("file", f"{out}/{leaf_name(leaf)}"),
                f"\\input{{Files/{src}/{leaf}}}",
                marker("endfile"),
            ]
    driver = (
        "\\documentclass[12pt,a4paper,openany]{book}\n"
        "\\usepackage{import}\n"
        "\\import{Files/-Preamble/}{-Preamble}\n"
        "\\begin{document}\n" + "\n".join(body) + "\n\\end{document}\n"
    )
    (work / "book.tex").write_text(driver, encoding="utf-8")
    return chapters


def main(argv=None):
    """Convert the book; returns the exit status."""
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--swift-shifter", required=True, type=Path)
    parser.add_argument("--pandoc", default="pandoc")
    parser.add_argument("--typst", default="typst")
    parser.add_argument("--source", type=Path, default=REPO / "Files")
    parser.add_argument("--out", type=Path, default=REPO / "chapters")
    args = parser.parse_args(argv)

    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp) / "book"
        shutil.copytree(args.source, work / "Files")
        chapters = build_driver(work)
        subprocess.run(
            [
                args.swift_shifter,
                "--output-dir",
                tmp,
                "convert",
                "typst",
                "book.tex",
            ],
            cwd=work,
            check=True,
        )
        draft = (Path(tmp) / "book.typ").read_text(encoding="utf-8")

    draft, failures = convert_math(draft, args.pandoc, args.typst)
    widths = image_widths(sorted(args.source.rglob("*.tex")))
    files = split_draft(draft)

    for out, chapter in chapters.items():
        folder = args.out / out
        folder.mkdir(parents=True, exist_ok=True)
        (folder / "ch.typ").write_text(chapter_file(chapter), encoding="utf-8")
    for name, text in files.items():
        depth = name.count("/") + 1
        header = f'#import "{"../" * depth}template.typ": *\n\n'
        text = finish(text, widths)
        if "/" not in name:
            text = unnumbered_headings(text)
        (args.out / f"{name}.typ").write_text(header + text, encoding="utf-8")

    # A formula left as mitex needs mitex imported; fix its source instead.
    for tex in failures:
        print(f"error: no Typst math for formula: {tex!r}", file=sys.stderr)
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
