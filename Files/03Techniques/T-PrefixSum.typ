#import "../../template.typ": *

== Prefix Sum
I thought about making a pun but it wasn't funny so never mind.

=== Introduction
Have you ever encountered a problem where you need to find the sum of a range $[a,b]$ in an array, and not just once, but many many times? In that case, adding them up one by one would be too slow to finish within the time limit. So what do we do?

Consider having an array $p$ where the $i$-th entry stores $sum_(k=1)^(i)a_k$, where $a_k$ denotes the $k$-th element of the array. Therefore, we can compute the sum of $[a,b]$ by calculating $p_b-p_(a-1)$.

As for the complexity: since $p_i=p_(i-1)+a_i$, we can compute everything with a single for loop, so the preprocessing complexity is $O(n)$. Querying also requires only a single subtraction, so the query complexity is $O(1)$.

=== Implementation
In practice, we often start the array index from $1$ because it is more convenient.

#code(title: [Prefix Sum Implementation])[
```cpp
int a[N],p[N];

void init(int n){
    for(int i=1;i<=n;++i){
        p[i]=p[i-1]+a[i];
    }
}

int query(int a,int b){
    return p[b]-p[a-1];
}
```
]

=== Extending to Higher Dimensions

Extending prefix sums to higher dimensions is straightforward; we just need to apply the inclusion-exclusion principle. The following uses two dimensions as an example; three or more dimensions follow the same pattern.

#code(title: [2D Prefix Sum])[
```cpp
const int N=1005,M=1005;
int a[N][M],psum[N][M];

void init(int n,int m){
    for(int i=1;i<=n;++i){
        for(int j=1;j<=m;++j){
            psum[i][j]=(
                psum[i-1][j]+
                psum[i][j-1]-
                psum[i-1][j-1]+
                a[i][j]
            );
        }
    }
}

void query(int l,int r,int u,int b){
    return (
        psum[b][r]-
        psum[b][l-1]-
        psum[u-1][r]+
        psum[u-1][l-1]
    );
}
```
]

=== Examples and Practice

==== Example: Leetcode 724 Find Pivot Index

*Problem Statement*

Given an array, find the pivot index.

Definition of pivot index: the sum of all numbers to the *left* of the pivot index *equals* the sum of all numbers to its right.

Output the leftmost pivot index.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`1 7 3 6 5 6`], [`3`],
  [Sample Input 2], [Sample Output 2],
  [`1 2 3`], [`-1`],
  [Sample Input 3], [Sample Output 3],
  [`2 1 -1`], [`0`],
)

==== Problem: APCS 3. Roundabout Exit

*Problem Statement*

There are $n$ rooms arranged in a circle, numbered $0$ to $n-1$.

There is a one-way path between rooms; from room $i$ you can move to room $(i+1)   "mod"   n$.

Each time you enter room $i$ you gain $p_i$ points (the starting room also gives points).

There are $m$ tasks in sequence. For the $i$-th task you need to collect $q_i$ points. For each task, if you start at room $s$ and collect enough points when you arrive at room $t$, then after completing the task you stop at room $(t+1)   "mod"   n$.

Starting from room $0$, given $m$ tasks, find the room number where you stop after completing the $m$-th task.

*Input Format*

The first line contains two positive integers $n,m$.

The second line contains $n$ positive integers $p_0,p_1,dots.c,p_(n-1)$; the total sum of $p$ does not exceed $10^9$.

The third line contains $m$ positive integers $q_0,q_1,dots.c,q_(n-1)$.

*Output Format*

Output a non-negative integer representing the room number where you stop at the end.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7 3`#linebreak()`2 1 5 4 3 5 3`#linebreak()`8 9 12`], [`4`],
  [Sample Input 2], [Sample Output 2],
  [`4 3`#linebreak()`1 3 5 7`#linebreak()`4 2 2`], [`3`],
)
