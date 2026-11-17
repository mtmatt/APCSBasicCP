"""Tests for convert.py. Run: python3 -m unittest discover scripts/tex2typ"""

import shutil
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).parent))

import convert  # noqa: E402

M = convert.MARK


class LeafNameTest(unittest.TestCase):
    def test_strips_prefix_and_kebab_cases(self):
        self.assertEqual(
            convert.leaf_name("T-AllLongestPath"), "all-longest-path"
        )
        self.assertEqual(convert.leaf_name("B-IOSpeedUp"), "io-speed-up")
        self.assertEqual(convert.leaf_name("BD-ImplementSTL"), "implement-stl")
        self.assertEqual(convert.leaf_name("S-Z-algo"), "z-algo")
        self.assertEqual(convert.leaf_name("BD-BIT"), "bit")

    def test_overrides(self):
        self.assertEqual(convert.leaf_name("AD-2DSeg"), "2d-seg")
        self.assertEqual(convert.leaf_name("AD-DinamicTree"), "dynamic-tree")


class ParseChapterTest(unittest.TestCase):
    def test_reads_title_label_and_body_in_order(self):
        tex = (
            "\\begin{chapter}{樹論}\\label{chapter:Tree}\n"
            "    \\input{T-Basic}\n"
            "    \\author{Ccucumber12}\n"
            "    % \\input{T-AllLongestPath}\n"
            "\\end{chapter}\n"
        )
        chapter = convert.parse_chapter(tex)
        self.assertEqual(chapter.title, "樹論")
        self.assertEqual(chapter.label, "chapter:Tree")
        self.assertEqual(
            chapter.body,
            [
                convert.Input("T-Basic", enabled=True),
                convert.Author("Ccucumber12"),
                convert.Input("T-AllLongestPath", enabled=False),
            ],
        )
        self.assertEqual(
            [item.stem for item in chapter.inputs],
            ["T-Basic", "T-AllLongestPath"],
        )

    def test_rejects_a_file_without_a_chapter(self):
        with self.assertRaises(ValueError):
            convert.parse_chapter("\\input{x}")

    def test_chapter_file(self):
        chapter = convert.Chapter(
            "樹論",
            "chapter:Tree",
            [
                convert.Input("T-Basic", enabled=True),
                convert.Author("A"),
                convert.Input("T-LCA", enabled=False),
            ],
        )
        self.assertEqual(
            convert.chapter_file(chapter),
            '#import "../../template.typ": *\n\n'
            "= 樹論 <chapter:Tree>\n\n"
            '#include "basic.typ"\n'
            '#set-author("A")\n'
            '// #include "lca.typ"\n',
        )


class PrepareTest(unittest.TestCase):
    def test_split_options(self):
        self.assertEqual(
            convert.split_options("caption={a, b},language=C++"),
            {"caption": "a, b", "language": "C++"},
        )

    def test_problem_and_example_become_markers(self):
        tex = convert.prepare("  \\problem APCS 3. 圓環出口\n\\example X\n")
        self.assertIn(f"{M} problem APCS 3. 圓環出口\n", tex)
        self.assertIn(f"{M} example X\n", tex)

    def test_environments_become_markers(self):
        tex = convert.prepare("\\begin{tip}\nhi\n\\end{tip}")
        self.assertEqual(tex, f"\n\n{M} begin tip\n\n\nhi\n\n\n{M} end\n\n")

    def test_listing_caption_and_language(self):
        tex = convert.prepare("\\begin{lstlisting}[caption=兩次DFS]\nx\n")
        self.assertEqual(
            tex,
            f"\n\n{M} listing 兩次DFS\n\n"
            "\\begin{lstlisting}[language=C++]\nx\n",
        )
        self.assertEqual(
            convert.prepare("\\begin{lstlisting}\n"),
            "\\begin{lstlisting}[language=C++]\n",
        )

    def test_lstset_caption_moves_onto_the_listing(self):
        tex = convert.prepare(
            "\\lstset{caption={KMP 實作}}\n"
            "\\begin{lstlisting}[language=C++]\nx\n"
        )
        self.assertEqual(
            tex,
            f"\n\n{M} listing KMP 實作\n\n"
            "\\begin{lstlisting}[language=C++]\nx\n",
        )

    def test_verb_needs_a_free_delimiter(self):
        self.assertEqual(convert.verb("a|b"), "\\verb!a|b!")
        with self.assertRaises(ValueError):
            convert.verb("|!+=")

    def test_parbox_sample_rows(self):
        tex = (
            "\\parbox[t]{7cm} % sample 1\n"
            "        { \\tt\n"
            "        % input\n"
            "        1\n"
            "        3 3 \\\\\n"
            "        a|b \\\\\n"
            "        } &\n"
            "        \\parbox[t]{7cm}\n"
            "        { \\tt\n"
            "        30 \\\\\n"
            "        } \\\\"
        )
        self.assertEqual(
            convert.prepare(tex),
            "\\verb|1 3 3| & \\verb|30| \\\\\n\\verb!a|b! &  \\\\",
        )

    def test_author_and_headings_become_markers(self):
        tex = convert.prepare(
            "  \\author{李卓岳}\n"
            "\\subsection*{程式實作}\n"
            "\\section*{A}\\subsubsection*{B}\n"
            "\\paragraph{Sift Up} 上浮\n"
        )
        self.assertIn(f"{M} author 李卓岳\n", tex)
        self.assertIn(f"{M} heading 3 程式實作\n", tex)
        self.assertIn(f"{M} heading 2 A\n", tex)
        self.assertIn(f"{M} heading 4 B\n", tex)
        self.assertIn("\\textbf{Sift Up} 上浮", tex)

    def test_image_paths_and_fixups(self):
        tex = convert.prepare("{../Images/A.png} $\\mod$")
        self.assertEqual(tex, "{Files/Images/A.png} $\\operatorname{mod}$")


class TypstStringTest(unittest.TestCase):
    def test_round_trip(self):
        for s in ['a "b" \\ c', "x\ny\tz", ""]:
            literal = convert.typst_string(s)
            self.assertEqual(convert.typst_unescape(literal[1:-1]), s)

    def test_unicode_escape(self):
        self.assertEqual(convert.typst_unescape("\\u{3b1}"), "α")


class MathTest(unittest.TestCase):
    def test_math_source(self):
        self.assertEqual(convert.math_source(" x ", False), "$x$")
        self.assertEqual(convert.math_source("x", True), "\\[x\\]")
        align = "\\begin{align*}a&=b\\end{align*}"
        self.assertEqual(convert.math_source(align, True), align)

    def test_cases_rows_get_a_column(self):
        self.assertEqual(
            convert.math_source(
                "\\begin{cases} a \\\\ b & c \\end{cases}", True
            ),
            "\\[\\begin{cases} a &\\\\ b & c \\end{cases}\\]",
        )

    def test_tidy_drops_escapes(self):
        self.assertEqual(
            convert.tidy_math("$f \\( n \\) = \\[ i \\, j \\]$"),
            "$f(n) = [i, j]$",
        )
        self.assertEqual(convert.tidy_math("$\\| v \\|$"), "$|v|$")

    def test_tidy_keeps_commas_in_calls(self):
        self.assertEqual(
            convert.tidy_math("$sqrt(a \\, b)$"), "$sqrt(a \\, b)$"
        )
        self.assertEqual(convert.tidy_math("$d p_(n \\, m)$"), "$d p_(n, m)$")

    def test_tidy_leaves_strings_alone(self):
        self.assertEqual(
            convert.tidy_math('$"a \\" \\(" \\($'), '$"a \\" \\(" ($'
        )

    def test_tidy_renames_pandoc_spellings(self):
        self.assertEqual(
            convert.tidy_math("$accent(O P_(i + 1), ⃗) accent(A B, ⃡)$"),
            "$arrow(O P_(i + 1)) arrow.l.r(A B)$",
        )
        self.assertEqual(
            convert.tidy_math('$upright("dp") med \\(mod med m \\)$'),
            '$"dp" quad (mod m)$',
        )
        self.assertEqual(convert.tidy_math("$a #h(0em) b$"), "$a b$")

    def test_tidy_cases(self):
        self.assertEqual(
            convert.tidy_math('$ cases(delim: "{", a & , b & x) $'),
            "$ cases(a, b & x) $",
        )
        self.assertEqual(convert.tidy_cases("cases(a"), "cases(a")

    def test_tidy_joins_calls(self):
        self.assertEqual(
            convert.tidy_math("$O \\( n log \\( n \\) \\) + d i s \\( a \\)$"),
            "$O(n log(n)) + d i s(a)$",
        )
        self.assertEqual(convert.tidy_math("$x_1 \\( a \\)$"), "$x_1 (a)$")
        self.assertEqual(
            convert.tidy_math(
                "$sum_(i = 1)^n \\( v_i \\) + p_i \\( 1 \\)$"
            ),
            "$sum_(i = 1)^n (v_i) + p_i (1)$",
        )

    def test_tidy_joins_cjk(self):
        self.assertEqual(
            convert.tidy_math('$以 第 n 個 麥 ， "已有字"$'),
            '$"以第" n "個麥，" "已有字"$',
        )

    @unittest.skipUnless(
        shutil.which("pandoc") and shutil.which("typst"), "needs pandoc, typst"
    )
    def test_convert_math(self):
        text = (
            '#mi(/*f1*/"f(n)=4n^3") and '
            '#mitex(/*f2*/"\\\\begin{cases} a \\\\\\\\ b \\\\end{cases}") '
            '#mi(/*f3*/"\\\\mod")'
        )
        out, failures = convert.convert_math(text)
        self.assertEqual(
            out,
            '$f(n) = 4 n^3$ and $ cases(a, b) $ '
            '#mi(/*f3*/"\\\\mod")',
        )
        self.assertEqual(failures, ["\\mod"])

    @unittest.skipUnless(
        shutil.which("pandoc") and shutil.which("typst"), "needs pandoc, typst"
    )
    def test_falls_back_to_pandoc_when_tidying_breaks_a_formula(self):
        with mock.patch.object(convert, "tidy_math", lambda typ: "$#nope$"):
            out, failures = convert.convert_math('#mi(/*f1*/"x")')
        self.assertEqual((out, failures), ("$x$", []))

    @unittest.skipUnless(shutil.which("typst"), "needs typst")
    def test_failing_math(self):
        self.assertEqual(convert.failing_math(["$a$", "$#nope$", None]), {1})

    def test_failing_math_without_a_line_is_an_error(self):
        with self.assertRaises(RuntimeError):
            convert.failing_math(["$a$"], typst="false")

    def test_no_formulas(self):
        self.assertEqual(convert.pandoc_math([]), [])

    def test_tidy_keeps_other_escapes_and_accents(self):
        self.assertEqual(convert.tidy_math("$a \\* b$"), "$a \\* b$")
        self.assertEqual(
            convert.tidy_math("$accent(a, ˜)$"), "$accent(a, ˜)$"
        )
        self.assertEqual(convert.accents("accent(a, ⃗"), "accent(a, ⃗")

    def test_tidy_spacing_leaves_strings_alone(self):
        self.assertEqual(
            convert.tidy_math('$upright("( 共 n 個 )") ( x )$'),
            '$"( 共 n 個 )" (x)$',
        )

    @unittest.skipUnless(shutil.which("pandoc"), "needs pandoc")
    def test_a_formula_blamed_after_giving_up_is_an_error(self):
        # Typst blames the formula after an unclosed one, which compiles as
        # `$$` once given up; that must not loop forever.
        with mock.patch.object(convert, "failing_math", return_value={1}):
            with self.assertRaises(RuntimeError):
                convert.convert_math('#mi(/*f0*/"x") #mi(/*f1*/"y")')


class DraftTest(unittest.TestCase):
    def test_split_draft(self):
        draft = (
            "#set page()\n"
            f"{M} file preface\n\nA\n\n{M} endfile\n"
            f"{M} file 05-tree\\/diameter\nB\n{M} endfile\n"
        )
        self.assertEqual(
            convert.split_draft(draft),
            {"preface": "A\n", "05-tree/diameter": "B\n"},
        )

    def test_finish_markers(self):
        text = (
            f"{M} problem 洛谷P3304 \\[SDOI2013\\]直徑\n"
            f"  {M} begin tip\n"
            "  hi\n"
            f"  {M} end\n"
            f"{M} listing 兩次DFS\n"
            "\n"
            "```cpp\n"
            "int x;\n"
            "```\n"
            "after\n"
        )
        self.assertEqual(
            convert.finish_markers(text),
            "#problem[洛谷P3304 \\[SDOI2013\\]直徑]\n"
            "  #tip[\n"
            "  hi\n"
            "  ]\n"
            "#listing([兩次DFS])[\n"
            "```cpp\n"
            "int x;\n"
            "```\n"
            "]\n"
            "after\n",
        )

    def test_split_draft_needs_paired_markers(self):
        for draft in [
            f"{M} file a\nA\n{M} file b\nB\n{M} endfile\n",
            f"A\n{M} endfile\n",
            f"{M} file a\nA\n",
        ]:
            with self.assertRaises(ValueError):
                convert.split_draft(draft)

    def test_listing_needs_code(self):
        with self.assertRaises(ValueError):
            convert.finish_markers(f"{M} listing X\n\nno code\n")

    def test_listing_code_must_close(self):
        with self.assertRaises(ValueError):
            convert.finish_markers(f"{M} listing X\n```cpp\nint a;\n")

    def test_unknown_marker(self):
        with self.assertRaises(ValueError):
            convert.finish_markers(f"{M} bogus\n")

    def test_images(self):
        text = (
            '#image("book-images/3-DSU.png", alt: "x")\n'
            '#image("book-images/4-Other.png")'
        )
        self.assertEqual(
            convert.finish_images(text, {"DSU.png": "70%"}),
            '#image("/Files/Images/DSU.png", width: 70%, alt: "x")\n'
            '#image("/Files/Images/Other.png")',
        )

    def test_image_widths(self):
        folder = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, folder)
        path = folder / "images.tex"
        path.write_text(
            "\\includegraphics[width=0.7\\textwidth]{../Images/A.png}\n"
            "\\includegraphics[width=\\textwidth]{../Images/B.png}\n"
            "\\includegraphics{../Images/C.png}\n",
            encoding="utf-8",
        )
        self.assertEqual(
            convert.image_widths([path]), {"A.png": "70%", "B.png": "100%"}
        )

    def test_finish_markers_for_author_and_heading(self):
        self.assertEqual(
            convert.finish_markers(
                f"{M} author 李卓岳\n{M} heading 3 程式 實作\n"
            ),
            '#set-author("李卓岳")\n'
            "#heading(level: 3, numbering: none, outlined: false)[程式 實作]\n",
        )

    def test_finish_text(self):
        text = (
            "不清楚的， 所以 a b 與\u00a0$n$\n"
            '#raw("x") #raw("a`b") $"甲 乙"$ "丙 丁"\n'
            "```cpp\n"
            "// 甲 乙\n"
            "```\n"
            "甲 乙\n"
        )
        self.assertEqual(
            convert.finish_text(text),
            "不清楚的，所以 a b 與~$n$\n"
            '`x` #raw("a`b") $"甲 乙"$ "丙 丁"\n'
            "```cpp\n"
            "// 甲 乙\n"
            "```\n"
            "甲乙\n",
        )

    def test_finish_text_leaves_math_across_lines_alone(self):
        text = (
            '$ a 以 第\\\n b 個 麥 $\n$#raw("q")$ #raw("q") 甲 乙\n'
            '他說 "甲 乙\n丙 丁" 與 `$` 戊 己\n'
        )
        self.assertEqual(
            convert.finish_text(text),
            '$ a 以 第\\\n b 個 麥 $\n$#raw("q")$ `q` 甲乙\n'
            '他說 "甲乙\n丙丁" 與 `$` 戊己\n',
        )

    def test_center_images(self):
        self.assertEqual(
            convert.center_images(
                '  #image("/a.png", width: 50%)\nx #image("b")\n'
                '#image("c") (d)'
            ),
            '  #align(center, image("/a.png", width: 50%))\nx #image("b")\n'
            '#image("c") (d)',
        )

    def test_unnumbered_headings(self):
        self.assertEqual(
            convert.unnumbered_headings("= 前言\n== a\n"),
            "#heading(numbering: none)[前言]\n== a\n",
        )


class SampleIoTest(unittest.TestCase):
    def table(self, *rows):
        return (
            "#table(\n  columns: 2,\n  align: (left, left,),\n"
            + "".join(f"  {row}\n" for row in rows)
            + ")"
        )

    def test_one_sample(self):
        text = self.table(
            "table.header([範例輸入 1], [範例輸出 1]),",
            '[#raw("6")], [#raw("1110")],',
            '[#raw("3 \\"1\\"")], [],',
        )
        self.assertEqual(
            convert.finish_tables(text),
            "#sample-io(\n"
            '  "6\\n3 \\"1\\"",\n'
            '  "1110",\n'
            "  input-title: [範例輸入 1],\n"
            "  output-title: [範例輸出 1],\n"
            ")",
        )

    def test_several_samples_and_lines_in_one_cell(self):
        text = self.table(
            "table.header([範例輸入 1], [範例輸出 1]),",
            '[#raw("1") #raw("2")], [#raw("3")],',
            "[範例輸入 2], [範例輸出 2],",
            '[#raw("4")], [#raw("5")],',
        )
        out = convert.finish_tables(text)
        self.assertEqual(out.count("#sample-io("), 2)
        self.assertIn('"1\\n2",\n  "3"', out)
        self.assertIn('"4",\n  "5",\n  input-title: [範例輸入 2]', out)

    def test_other_tables_are_centred(self):
        for text in [
            self.table("table.header([a], [b]),", "[1], [2],"),
            self.table(
                "table.header([範例輸入 1], [範例輸出 1]),",
                "[|1 3|], [#raw(\"2\")],",
            ),
            "#table(\n  columns: 3,\n)",
        ]:
            body = text.removeprefix("#table(\n").removesuffix("\n)")
            self.assertEqual(
                convert.finish_tables(text),
                f"#align(center, table(\n{body}\n))",
            )


# Stands in for swift-shifter: keeps the text of the files the document reads
# in, writes listings as code blocks and escapes slashes as swift-shifter does.
FAKE_SWIFT_SHIFTER = """\
import re, sys
from pathlib import Path
out = Path(sys.argv[sys.argv.index("--output-dir") + 1])
lines = ['#import "@preview/mitex:0.2.7": mitex, mi']
for line in Path("book.tex").read_text().splitlines():
    m = re.fullmatch(r"\\\\input\\{(.*)\\}", line)
    text = Path(m.group(1) + ".tex").read_text() if m else line
    text = text.replace("\\\\begin{lstlisting}[language=C++]", "```cpp")
    text = text.replace("\\\\end{lstlisting}", "```")
    for out_line in text.splitlines():
        marked = "ZZMARK" in out_line
        lines.append(out_line.replace("/", "\\\\/") if marked else out_line)
(out / "book.typ").write_text("\\n".join(lines))
"""


class MainTest(unittest.TestCase):
    def setUp(self):
        tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, tmp)
        self.source, self.out = tmp / "Files", tmp / "chapters"
        self.fake = tmp / "swift-shifter"
        self.fake.write_text(f"#!{sys.executable}\n{FAKE_SWIFT_SHIFTER}")
        self.fake.chmod(0o755)
        self.write("-Preface.tex", "= 前言\n\n序。\n")
        self.write("-Preamble/-Preamble.tex", "")
        self.write(
            "05Tree/Tree.tex",
            "\\begin{chapter}{樹論}\\label{chapter:Tree}\n"
            "    \\input{T-Diameter}\n"
            "\\end{chapter}\n",
        )
        self.write(
            "05Tree/T-Diameter.tex",
            textwrap.dedent(
                """\
                == 樹直徑

                \\problem 洛谷P3304

                #image("book-images/0-Tree.png")

                \\begin{lstlisting}[caption=兩次DFS]
                int a;
                \\end{lstlisting}
                """
            )
            + "\\includegraphics[width=0.5\\textwidth]{../Images/Tree.png}\n",
        )

    def write(self, name, text):
        path = self.source / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")

    def run_main(self):
        patches = [
            mock.patch.object(convert, "STANDALONE", [("-Preface", "preface")]),
            mock.patch.object(
                convert, "CHAPTERS", [("05Tree", "Tree", "05-tree")]
            ),
        ]
        for patch in patches:
            patch.start()
            self.addCleanup(patch.stop)
        return convert.main(
            [
                "--swift-shifter",
                str(self.fake),
                "--source",
                str(self.source),
                "--out",
                str(self.out),
            ]
        )

    @unittest.skipUnless(
        shutil.which("pandoc") and shutil.which("typst"), "needs pandoc, typst"
    )
    def test_writes_chapters(self):
        self.assertEqual(self.run_main(), 0)
        self.assertEqual(
            (self.out / "preface.typ").read_text(),
            '#import "../template.typ": *\n\n'
            "#heading(numbering: none)[前言]\n\n序。\n",
        )
        self.assertEqual(
            (self.out / "05-tree/ch.typ").read_text(),
            '#import "../../template.typ": *\n\n'
            "= 樹論 <chapter:Tree>\n\n"
            '#include "diameter.typ"\n',
        )
        diameter = (self.out / "05-tree/diameter.typ").read_text()
        self.assertTrue(diameter.startswith('#import "../../template.typ": *'))
        self.assertIn("#problem[洛谷P3304]", diameter)
        self.assertIn(
            '#align(center, image("/Files/Images/Tree.png", width: 50%))',
            diameter,
        )
        self.assertIn(
            "#listing([兩次DFS])[\n```cpp\nint a;\n```\n]", diameter
        )

    @unittest.skipUnless(
        shutil.which("pandoc") and shutil.which("typst"), "needs pandoc, typst"
    )
    def test_fails_on_formulas_without_typst_math(self):
        self.write("-Preface.tex", '#mi(/*f0*/"\\\\mod")\n')
        with mock.patch("sys.stderr"):
            self.assertEqual(self.run_main(), 1)


if __name__ == "__main__":
    unittest.main()
