#import "../../template.typ": *

== Complexity
There are three notations for complexity, one of which is called O-notation. In most cases, Big-O notation is used as the standard for analysis. Big-O notation focuses on how a function grows as $n$ approaches infinity. For the sake of simplicity, algorithm analysis typically omits three things:

+ Use a tight bound — in simple terms, use the smallest possible complexity (the most efficient representation)
+ Ignore constants
+ Ignore lower-order terms


Taking $f(n)=4n^3+n^2+3$ as an example, it can be expressed as $O(n^3)$.

Complexity is divided into time and space. Generally speaking, space is more lenient, while time is more constrained. In most cases the time limit is 1 second. The table below shows reference data sizes that can be handled within such a time limit. Entries further to the right are less commonly encountered.

#table(columns: 8, stroke: .5pt, inset: 5pt,
  [$O(1)$],
  [$O(log(n))$],
  [$O(n)$],
  [$O(n log(n))$],
  [$O(n^2)$],
  [$O(n^3)$],
  [$O(2^n)$],
  [$O(n!)$],
  [$2^(63)-1$],
  [$2^(63)-1$],
  [$10^7$],
  [$10^6$],
  [$5 times 10^3$],
  [$500$],
  [$20$],
  [$10$],
)
#align(center)[_Complexity vs. Data Size Reference_]


For a more detailed introduction to complexity, refer to AP325.
