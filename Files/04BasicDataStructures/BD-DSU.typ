#import "../../template.typ": *

== Disjoint Set Union
=== Introduction
Disjoint Set Union, also known as DSU, is a data structure specifically designed to handle union and find operations on sets.

We often encounter problems like: are two people in the same group, or how to merge two groups. If we use a set to perform these operations, a query takes $O(log(n))$ and a union takes $O(n log(n))$. By using DSU, we can reduce the query time complexity to $O(alpha(n))$, where $alpha(n)$ is the inverse of the Ackermann function $A(n,n)$. Intuitively, within the variable ranges typical in competitive programming, it will never exceed $4$, so it can be treated as a constant.

=== Concept
DSU is almost always implemented using the concept of trees, so if you do not yet know what a tree is, you can flip to the tree section first.

Every element in DSU stores one piece of information: who is above it. You can think of it like this — above you is your senior, above your senior is your teacher, above your teacher is the school principal, and you all belong to Yilan High School. We can draw the following diagram as a reference.

*Find*

The arrows in the diagram indicate who is above a given node. During a find operation, simply keep going up until you reach the topmost node. If two nodes share the same topmost node, we say those two nodes belong to the same set.

#align(center)[#image("../Images/DSU.png", width: 100%)]
#align(center)[_DSU Diagram_]

*Union*

Merging two groups (a, b) is very simple: just connect the top of node a with the top of node b — that is, set the top of a's root to be above the top of b's root, or vice versa. Either direction works.

=== Union by Rank (Heuristic Merging)
Union by rank improves efficiency by attaching the root of the larger set on top of the root of the smaller set. A DSU without union by rank has an expected complexity of $O(n)$; adding union by rank reduces this to $O(log(n))$.

=== Path Compression
If during a find operation we connect all traversed nodes directly to the topmost node, we can further improve the complexity to an average of $O(alpha(n))$, which can be treated as the constant $4$ in competitive programming.

=== Implementation
In practice, path compression alone is usually sufficient for most tasks, so union by rank can be omitted.

#code(title: [DSU Implementation])[
```cpp
const int N=100010;
int dsu[N];

int find(int a){
    if(dsu[a]==a){
        return a;
    }
    // Path compression
    return dsu[a]=find(dsu[a]);
}

int Union(int a,int b){
    dsu[find(a)]=dsu[find(b)];
}
```
]

=== Examples and Practice

==== Problem: Implement union by rank.

==== Problem: UVA793 A - Network Connections

*Problem Statement*

There are $n$ computers numbered $1$ through $n$, followed by a series of commands. The command `c a b` means connect $a$ and $b$; the command `q a b` means query whether $a$ and $b$ are connected. Finally, output the total number of queries that received a "connected" answer and the total number that received a "not connected" answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`10`#linebreak()`c 1 5`#linebreak()`c 2 7`#linebreak()`q 7 1`#linebreak()`c 3 9`#linebreak()`q 9 6`#linebreak()`c 2 5`#linebreak()`q 7 5`], [`1,2`],
)

*Small Detail*

UVA is quite old and has some quirky rules, such as not having a newline at the end of the last line. You must follow these rules to receive `AC`.

==== Problem: ZJ d831 Graduation Trip

*Problem Statement*

The bonds of friendship forged over many years are finally blooming in this graduation season.

In recent days, classmates have been passionately discussing graduation trip destinations at all hours. Xiao Ming says that if they go to Leofoo Village, they can also visit Window on China; Xiao Mei says that if they go to Hengchun, Kenting is just a few dozen kilometers away and they must go there too; Xiao Hua mentions that Little Ghost Lake and Big Ghost Lake seem to be close together and both look like fun places.

As class president, after hearing so many "if we go here we can also go there" suggestions from classmates, you decide to find the graduation trip that lets the class visit the most attractions.

*Input Description*

There are multiple test cases, ending at EOF.

The first line of each test case contains two positive integers $n (n <= 10^6)$ and $m (m <= 10^5)$, indicating there are $n$ attractions numbered $0$ through $(n-1)$. The next $m$ lines each contain two integers $a$ and $b   (0 <= a,b<n)$, meaning visiting $a$ also allows visiting $b$ (and vice versa).

*Output Description*

Output a single number representing the maximum number of attractions that can be visited on the graduation trip.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6 4`#linebreak()`0 1`#linebreak()`2 3`#linebreak()`1 3`#linebreak()`5 4`#linebreak()`1000000 0`#linebreak()`1000000 1`#linebreak()`0 999999`], [`4`#linebreak()`1`#linebreak()`2`],
)

==== Problem: Luogu P1536 Village Connectivity

*Problem Statement*

A city surveyed its town transportation conditions and produced a road statistics table. The table lists the towns directly connected by each road. The city government's "Village Connectivity Project" aims to make any two towns in the city reachable from each other (not necessarily via a direct road — indirect connectivity is sufficient). Calculate the minimum number of additional roads that need to be built.

*Input Description*

The input contains several test cases. The first line of each test case contains two positive integers separated by a space: the number of towns $n$ and the number of roads $m$. The next $m$ lines correspond to $m$ roads, each containing a pair of positive integers separated by a space representing the two towns directly connected by that road. For simplicity, towns are numbered $1$ through $n$.

Note: there may be multiple roads between two towns.

The last line of the input is a single integer $0$, marking the end of the test data.

*Output Description*

For each test case, output one integer on its own line representing the minimum number of roads that still need to be built.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 2`#linebreak()`1 3`#linebreak()`4 3`#linebreak()`3 3`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`2 3`#linebreak()`5 2`#linebreak()`1 2`#linebreak()`3 5`#linebreak()`999 0`#linebreak()`0`], [`1`#linebreak()`0`#linebreak()`2`#linebreak()`998`],
)
