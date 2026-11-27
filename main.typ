#import "template.typ": *
#show: conf

#title()

#set page(numbering: "i")
#outline(title: [目錄], depth: 3)
#outline(title: [程式碼], target: figure.where(kind: "listing"))

#include "chapters/preface.typ"
// #include "chapters/thanks.typ"

#set page(numbering: "1")
#counter(page).update(1)

#include "chapters/01-coding-style/ch.typ"
#include "chapters/02-basic-skills/ch.typ"
#include "chapters/03-techniques/ch.typ"
#include "chapters/04-basic-data-structures/ch.typ"
#include "chapters/05-tree/ch.typ"
#include "chapters/06-graph-basic/ch.typ"
#include "chapters/07-mathematics/ch.typ"
#include "chapters/08-advanced-ds/ch.typ"
#include "chapters/09-dynamic-programming/ch.typ"
#include "chapters/10-geometry/ch.typ"
#include "chapters/11-advanced-techniques/ch.typ"
#include "chapters/12-more-problems/ch.typ"
#include "chapters/13-strings/ch.typ"
#include "chapters/reference.typ"
