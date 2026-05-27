#import "../../template.typ": *

== All Longest Paths
The following content is excerpted from Antti Laaksonen's Competitive Programmer's Handbook.

=== Concept
The next problem we consider is computing, for each node in the tree, the
length of the longest path starting from that node. This can be seen as a
generalization of the tree diameter problem, since the largest such path
length equals the diameter. Similarly, this problem can be solved in
$O \( n \)$ time.

As an example, consider the following tree:

#figure(image("../Images/Tree2.png", width: 50.0%),
  caption: [
  ]
)

Let maxLength(x) denote the length of the longest path starting from node x.
For example, in the tree above, maxLength(4) = 3 because there is a path
4 → 1 → 2 → 6. The complete table of values is:

#block[
#table(columns: 2, stroke: .5pt, inset: 5pt,
  [], [],
    [1], [2],
    [2], [2],
    [3], [3],
    [4], [3],
    [5], [3],
    [6], [3],
)

]
A good starting point for solving this problem is to root the tree at an
arbitrary node:

#figure(image("../Images/Tree3.png", width: 50.0%),
  caption: [
  ]
)

The first part of the problem is to compute, for each node x, the maximum
path length going through its children. For example, the longest path from
node 1 goes through its child node 2.

This part can be solved easily in $O \( n \)$ time using dynamic programming,
just as before. Then the second part of the problem is to compute, for each
node x, the maximum path length going through its parent p. For example, the
longest path from node 3 goes through its parent node 1.

At first glance it seems we should choose the longest path starting from p.
However, this does not always work, because the longest path from p may pass
through x itself. Here is an example: $2 arrow.r 1 arrow.r 4$.

Nevertheless, we can still solve the second part in $O \( n \)$ time by
storing two maximum lengths for each node x:

- $m a x L e n g t h_1 \( x \)$: the length of the longest path starting from node x.

- $m a x L e n g t h_2 \( x \)$: the length of the longest path starting from node x
  in a different direction.

For example, in the figure above, $m a x L e n g t h_1 \( x \) = 2$,
using the path 1 → 2 → 5, while $m a x L e n g t h_2 \( x \) = 1$, using
the path 1 → 3.

Finally, if the path corresponding to $m a x L e n g t h_1 \( p \)$ passes
through x, we conclude the maximum length is
$m a x L e n g t h_2 \( p \) + 1$; otherwise, the maximum length is
$m a x L e n g t h_1 \( p \) + 1$.

=== Summary
Honestly, I have never seen a problem like this in a competition, but there
are many problems I have not encountered in recent years, so I think it may
come in handy and have translated this section for you to read.

=== Examples and Exercises
==== Problem: CSES task 1132 Tree Distances I
*Problem Statement*

You are given a tree consisting of n nodes.

Your task is to find, for each node, the maximum distance to any other node.

*Input Format*

The first line contains an integer $n$: the number of nodes. The nodes are
numbered $1 \, 2 \, dots.h.c \, n$.

The next $n - 1$ lines describe the edges. Each line contains two integers
$a$ and $b$: there is an edge between nodes $a$ and $b$.

*Output Format*

Output $n$ integers: for each node
$1 \, 2 \, dots.h.c \, n$, print the maximum distance to any other node.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`3 4`#linebreak()`3 5`], [`2 3 2 3 3`],
)
