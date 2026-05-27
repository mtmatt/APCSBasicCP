#import "../../template.typ": *

== Variable Naming
In this section we will explore the meaning behind variable names. In industry, variable names should contain as much information as possible so that teammates can understand the code just by reading the names. However, some people believe that in competitive programming, variable names should be as concise as possible.

=== Choosing Between Brevity and Clarity
I admit that in competitive programming it is unlikely you will use variable names as long as those in professional settings, since competitions are a race against time. But overly short or even meaningless names can make debugging difficult, so there are some compromise approaches that try to address both sides of the problem.

=== Abbreviations
Using English abbreviations when naming variables is a common way to keep code concise. The following is a simple table listing abbreviations I might use and their meanings.
#table(columns: 7, stroke: .5pt, inset: 5pt,
  [*Abbreviation*],
  [ct],
  [isv],
  [mx],
  [mn],
  [idx],
  [num],
  [*Meaning*],
  [count],
  [is valid],
  [max],
  [min],
  [index],
  [number],
)


=== Compound Words
For compound words, we can use two naming conventions.

+ Add an underscore, e.g.: `item_number`.
+ Capitalize the first letter of each word after the first, e.g.: `itemNumber`


=== Other
For other naming conventions, refer to Chapter 11 of *Code Complete*, "The Power of Variable Names".
