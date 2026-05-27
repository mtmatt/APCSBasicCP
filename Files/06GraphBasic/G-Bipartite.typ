#import "../../template.typ": *

== Bipartite Graph Detection
=== Concept
Is there a way to partition the vertices of a graph into two groups such that no two vertices within the same group share an edge? See the figure below.

#figure(image("../Images/Graph3.jpg", width: 50.0%),
  caption: [
    Bipartite Graph
  ]
)

==== Detection Method

Imagine coloring the graph with colors 1 and 2 so that adjacent vertices always have different colors. If this is impossible, the graph is not bipartite. In practice, if a neighbor already has the same color as you, it cannot be done.

=== Implementation
#code(title: [Bipartite Graph Detection])[
  ```cpp
int color[N];
bool isBipartiteGraph(int n){
    for(auto u:g[n]){
        // use color==0 in place of bool isv[N];
        if(color[u]==0){
            // a neat trick: color[u]=color[n]^3;
            color[u]=color[n]%2+1;
            if(!isBipartiteGraph(u))
                return false;
        }else if(color[u]==color[n]){
            return false;
        }
    }
    return true;
}
  ```
]

=== Examples and Practice
==== Problem: TIOJ 1209 Graph Theory — Bipartite Graph Test
*Problem Statement*

Given a graph, determine whether it is a bipartite graph.

A bipartite graph is one where there exists a way to partition all vertices into two sets X and Y such that no two vertices within X or within Y are adjacent to each other.

*Input Format*

The input may contain multiple test cases.

The first line of each test case contains two integers $n \, m \( 1 lt.eq n lt.eq 40 \, 000 ， 0 lt.eq m lt.eq 500 \, 000 \)$,
representing the number of vertices and edges. Vertices are numbered 1 to n.

The following m lines each contain two space-separated positive integers representing the two endpoints of an edge.
When $n = m = 0$, the input ends.

*Output Format*

For each test case, output Yes if the graph is bipartite, otherwise output No.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 2`#linebreak()`2 3`#linebreak()`1 2`#linebreak()`3 3`#linebreak()`1 2`#linebreak()`2 3`#linebreak()`3 1`#linebreak()`0 0`], [`Yes`#linebreak()`No`],
)
==== Problem: ZJ g598 True or False Subgraph
*Problem Statement*

An intelligence agency has n employees. The director secretly divides them into two groups A and B
without telling anyone else, and distributes a cooperation list to the group leaders. The cooperation list consists of many pairs;
each pair $x \, y$ means x and y need to cooperate on a task, and it is guaranteed that x and y
are never in the same group (A or B).

The group leader accidentally lost the cooperation list, with only m pairs
remaining. To recover the lost data, the group leader sends out p investigators numbered 1 to
p to look into the cooperation relationships. Each investigator returns exactly k pairs of data.

Some investigators return data that contradicts the group leader's remaining records (meaning adding their k pairs
together with the remaining m pairs would create a contradiction with the fact that everyone is split into
groups A and B). Output the numbers of investigators who returned incorrect results in ascending order.
It is guaranteed that at least one and at most three investigators are wrong.

Additionally, it is guaranteed that if an investigator's k pairs do not contradict the group leader's remaining m pairs,
then the investigator's data is consistent with the original A, B grouping.

*Input Format*

The first line contains two positive integers n and m.

The second line contains 2m non-negative integers forming m pairs, representing the m remaining pairs.

The third line contains two positive integers p and k.

The following p lines each contain 2k non-negative integers forming k pairs, representing one investigator's findings.

*Output Format*

Output the numbers of contradicting investigators in ascending order, one per line.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7 5`#linebreak()`0 1 0 2 1 3 2 3 4 5`#linebreak()`2 3`#linebreak()`0 6 2 4 3 6`#linebreak()`0 6 0 3 3 5`], [`2`],
)
==== Problem: AtCoder ABC 282D Make Bipartite 2
*Problem Statement*

Given a simple undirected graph $G$ with $N$ vertices and $M$ edges (no self-loops or multi-edges). For $i = 1 \, 2 \, dots.h \, M$, the $i$-th edge connects vertices $u_i$ and $v_i$.

Count the number of integer pairs $\( u \, v \)$ with $1 lt.eq u < v lt.eq N$ satisfying the following two conditions:

There is no edge in $G$ connecting vertices $u$ and $v$.

Adding an edge connecting vertices $u$ and $v$ to $G$ results in a bipartite graph.

$2 lt.eq N lt.eq 2 times 10^5$

$0 lt.eq M lt.eq min 2 times 10^5 \, N \( N - 1 \) \/ 2$

$1 lt.eq u_i \, v_i lt.eq N$

*Input Format*

Input is given from standard input in the following format.

$N$ $M$

$u_1$ $v_1$

$u_2$ $v_2$

$dots.v$

$u_M$ $v_M$

*Output Format*

Print the answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 4`#linebreak()`4 2`#linebreak()`3 1`#linebreak()`5 2`#linebreak()`3 2`], [`2`],
)
