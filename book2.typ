#import "template.typ": *
#show: conf

#title(subtitle: subtitle + "（下）")

#set page(numbering: "i")
#outline(title: [目錄], depth: 3)
#outline(title: [程式碼], target: figure.where(kind: "listing"))

#include "chapters/preface.typ"

#set page(numbering: "1")
#counter(page).update(1)

// Chapters keep the numbers they have in the full book (main.typ).
#counter(heading).update(6)

#include "chapters/07-mathematics/ch.typ"
#include "chapters/08-advanced-ds/ch.typ"
#include "chapters/09-dynamic-programming/ch.typ"
#include "chapters/10-geometry/ch.typ"
#include "chapters/11-advanced-techniques/ch.typ"
#include "chapters/12-more-problems/ch.typ"
#include "chapters/13-strings/ch.typ"
#include "chapters/reference.typ"
