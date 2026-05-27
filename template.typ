#import "@preview/showybox:2.0.4": showybox
#import "@preview/cetz:0.3.4"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/theorion:0.3.3": *
#import cosmos.clouds: *
#import "@preview/lilaq:0.6.0"
#import "@preview/gentle-clues:1.3.1": *
#import "@preview/fontawesome:0.6.0": *

#let author = "ShangJhe Li"
#let doc-name = "APCS and Competitive Programming Fundamentals"
#let subtitle = "An Introduction to Algorithms and Data Structures"

#let latin-font = "Libertinus Serif"
#let mono-font = "SauceCodePro NFM"
#let mandrin-font = "AR PL KaitiM Big5"

#let tip(title: "Tip", ..args) = clue(
  icon: fa-lightbulb(),
  title: title,
  border-color: yellow,
  accent-color: yellow,
  ..args,
)

#let code(title: "Code", ..args) = clue(
  icon: fa-code(),
  title: title,
  border-color: rgb("#7287fd"),
  accent-color: rgb("#7287fd"),
  ..args,
)

#let warning(title: "Warning", ..args) = clue(
  icon: fa-warning(),
  title: title,
  border-color: rgb("#ffb639"),
  accent-color: rgb("#ffb639"),
  ..args,
)

#let tasks(title: "Tasks", ..args) = clue(
  icon: fa-tasks(),
  title: title,
  border-color: rgb("#9774ff"),
  accent-color: rgb("#9774ff"),
  ..args,
)

#let note(title: "Note", ..args) = clue(
  icon: fa-note-sticky(),
  title: title,
  border-color: rgb("#26e1d1"),
  accent-color: rgb("#26e1d1"),
  ..args,
)

#let instruction(title: "Instruction", ..args) = clue(
  icon: fa-terminal(),
  title: title,
  border-color: rgb("#e04689"),
  accent-color: rgb("#e04689"),
  ..args,
)

#let title(
  subtitle: subtitle,
  date: datetime.today().display(),
) = {
  page(
    margin: 0pt,
    header: none,
    footer: none,
    numbering: none,
  )[
    #set text(font: (latin-font, mandrin-font))
    #rect(
      width: 100%,
      height: 100%,
      stroke: none,
      inset: (x: 2.4cm, y: 2.6cm),
    )[
      #align(right)[
        #stack(dir: ttb, spacing: 0.35em)[
          #box(width: 3.4cm, height: 1.4pt, fill: black)
        ]
      ]
      #v(1fr)
      #align(horizon)[
        #block(width: 100%)[
          #box(width: 2.8cm, height: 3pt, fill: rgb("#a23b2a"))
          #v(0.75cm)
          #text(size: 38pt, weight: "bold", doc-name)
          #v(0.65cm)
          #box(width: 8cm, height: 1pt, fill: rgb("#2f3437"))
          #v(0.55cm)
          #text(size: 15pt, fill: rgb("#4d5659"), subtitle)
        ]
      ]
      #v(1fr)
      #grid(columns: (1fr, auto), column-gutter: 1.4cm)[
        #stack(dir: ttb, spacing: 0.4em)[
          #text(size: 9pt, fill: rgb("#5f686b"))[Author]
          #text(size: 14pt, weight: "semibold", author)
        ]
      ][
        #stack(dir: ttb, spacing: 0.4em)[
          #text(size: 9pt, fill: rgb("#5f686b"))[Date]
          #text(size: 14pt, weight: "semibold", date)
        ]
      ]
    ]
  ]
  counter(page).update(1)
}

#let chapter-heading(it) = {
  pagebreak(weak: true)
  v(1.2cm)
  block(width: 100%)[
    #if it.numbering == none [
      #align(center)[
        #box(width: 100%, height: 1.2pt, fill: rgb("#2f3437"))
        #v(-0.9em)
        #text(size: 24pt, weight: "bold", it.body)
        #v(-0.9em)
        #box(width: 100%, height: 1.2pt, fill: rgb("#2f3437"))
      ]
    ] else [
      #v(-2em)
      #align(center)[
        #box(width: 100%, height: 1.2pt, fill: rgb("#2f3437"))
        #v(-0.9em)
        #text(size: 24pt, weight: "bold", fill: rgb("#a23b2a"))[
          Chapter #context counter(heading).display("1")
        ]
        #v(-0.9em)
        #box(width: 100%, height: 1.2pt, fill: rgb("#2f3437"))

        #text(size: 24pt, weight: "bold", it.body)
        #v(2em)
      ]
    ]
  ]
  v(0.85cm)
}

#let conf(doc) = [
  #show: codly-init.with()
  #codly(languages: codly-languages)
  #show: show-theorion

  #set page(
    paper: "a4",
    margin: (x: 2cm, y: 2.5cm),
    numbering: "1",
    header: context [
      #let page-num = counter(page).get().first()
      #let chapter-on-page = query(heading.where(level: 1)).any(
        it => counter(page).at(it.location()).first() == page-num,
      )
      #if not chapter-on-page [
        _ #doc-name _
        #h(1fr)
        #box(fill: black, width: 100%, height: 1pt)
      ]
    ],
    footer: context [
      #box(fill: black, width: 100%, height: 1pt)
      #author
      #h(1fr)
      #counter(page).display("1")
    ],
  )

  #set text(
    font: (latin-font, mandrin-font),
    size: 12pt,
    cjk-latin-spacing: auto,
  )
  #set par(justify: true)
  #set heading(numbering: (..nums) => nums.pos().map(str).join(".") + " ")
  #show heading.where(level: 1): chapter-heading
  #set list(indent: 1em)
  #set enum(indent: 1em)
  #show raw: set text(font: mono-font)
  #show: gentle-clues.with(breakable: true)

  #doc
]
