#import "template.typ": *
#show: conf

#title(subtitle: subtitle + "（上）")

#set page(numbering: "i")
#outline(title: [目錄], depth: 3)
#outline(title: [程式碼], target: figure.where(kind: "listing"))

#include "chapters/preface.typ"

#set page(numbering: "1")
#counter(page).update(1)

#include "chapters/01-coding-style/ch.typ"
#include "chapters/02-basic-skills/ch.typ"
#include "chapters/03-techniques/ch.typ"
#include "chapters/04-basic-data-structures/ch.typ"
#include "chapters/05-tree/ch.typ"
#include "chapters/06-graph-basic/ch.typ"
#include "chapters/reference.typ"
