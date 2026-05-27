#import "../../template.typ": *

== Lowest Common Ancestor
=== Concept
Consider a rooted tree. We want to find the Lowest Common Ancestor (LCA) of
any two nodes. Using the tree diagram as an example, with node 2 as the root,
we want to find the LCA of nodes 5 and 8. The answer is node 1.

We can quickly think of an $O \( n \)$ method to find the LCA of any two nodes.
First, run a DFS to precompute the distance from each node to the root. Then,
to query the LCA of u and v, follow these steps:

- If u is closer to the root, repeatedly move v closer to the root; otherwise move u closer.

- Keep u and v at the same depth and move them upward together.

- When they meet at the same node, that is the LCA.

#code(title: [O(n) LCA Algorithm])[
  ```cpp
int dis[N],par[N];
void dfs(int n,int p,int d){
    dis[n]=d;
    for(auto u:g[n]) if(u!=p){
        par[u]=n;
        dfs(u,n,d+1);
    }
}

int query(int u,int v){
    if(dis[u]>dis[v]){
        swap(u,v);
    }
    while(dis[v]>dis[u]){
        v=par[v];
    }

    while(u!=v){
        u=par[u];
        v=par[v];
    }

    return u;
}
  ```
]

However, this speed is not very satisfying. Is there a way to speed up the
query? Yes — at the cost of a little extra preprocessing time.

=== Binary Lifting
When finding the LCA above, we moved up one step at a time. If we could jump
many steps at once, would it be much faster? Indeed, we could precompute
which node is $1 tilde.op n$ steps above node u and then do a binary search,
but that preprocessing would take $O \( n^2 \)$ time, which is too slow.
Instead, we settle for precomputing the ancestors at distances
$1 \, 2 \, 4 \, dots.h.c \, 2^k \, dots.h.c \, 2^(log_2 \( n \))$ steps up.
This takes $O \( n log \( n \) \)$ preprocessing time and allows each query
to be answered in $O \( log \( n \) \)$ time.

=== Implementation
#code(title: [O(log(n)) LCA Query Algorithm])[
  ```cpp
vector<int> g[100010];
int lca[30][100010];
int lev[100010],root;

void init(int x=root,int p=root){
    lca[0][x]=p;
    lev[x]=lev[p]+1;
    for(auto i:g[x]) if(i != p)
        init(i,x);
}

void build(int n){
    for(int i=1;i<=log2(n);++i)
        for(int j=1;j<=n;++j)
            lca[i][j]=lca[i-1][lca[i-1][j]];
}

int query(int a,int b){
    if(lev[a]<lev[b]) swap(a,b);
    for(int i=25;i>=0;--i)
        if(lev[lca[i][a]]>=lev[b])
            a=lca[i][a];
    if(a==b) return a;

    for(int i=25;i>=0;--i){
        if(lca[i][a]!=lca[i][b]){
            a=lca[i][a];
            b=lca[i][b];
        }
    }
    return lca[0][a];
}
  ```
]

=== Examples and Exercises
==== Problem: Luogu P3379 [Template] Lowest Common Ancestor (LCA)
*Problem Statement*

Given a rooted multi-way tree, find the lowest common ancestor of two
specified nodes.

*Input Format*

The first line contains three positive integers
$N \, M \, S$, representing the number of tree nodes, the number of queries,
and the root node number respectively.

The next $N - 1$ lines each contain two positive integers $x \, y$ indicating
there is a direct edge between nodes $x$ and $y$ (guaranteed to form a tree).

The next $M$ lines each contain two positive integers $a \, b$ representing a
query for the LCA of nodes $a$ and $b$.

$100 %$ of the data satisfies $1 lt.eq N \, M lt.eq 500000$, $1 lt.eq x \, y \, a \, b lt.eq N$, $a eq.not b$ not guaranteed.

*Output Format*

Output $M$ lines, each containing one positive integer, which is the result of
the corresponding query, in the order they appear in the input.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 5 4`#linebreak()`3 1`#linebreak()`2 4`#linebreak()`5 1`#linebreak()`1 4`#linebreak()`2 4`#linebreak()`3 2`#linebreak()`3 5`#linebreak()`1 2`#linebreak()`4 5`], [`4`#linebreak()`4`#linebreak()`1`#linebreak()`4`#linebreak()`4`],
)
==== Problem: CF 191 C Fools and Roads
*Problem Statement*

They say Berland has two problems: fools and roads. Moreover, Berland has n
cities inhabited by fools and connected by roads. All roads in Berland are
bidirectional. Because there are so many fools in Berland, there is exactly
one path between every pair of cities (otherwise fools would get angry). Also,
there is at most one simple path between every pair of cities (otherwise fools
would get lost).

But that is not all that is special about Berland. In this country, fools
sometimes visit each other, destroying roads in the process. Fools are not
smart, so they only use simple paths.

A simple path is a path that visits each city in Berland at most once.

The Berland government knows the paths used by the fools. Help the government
count how many different fools travel along each road.

The fools' paths are given in the input.

*Input Format*

The first line contains an integer $n \( 2 lt.eq n lt.eq 10^5 \)$ --- the number of cities.

The next $n - 1$ lines each contain two space-separated integers $u_i$, $v_i$
$\( 1 lt.eq u_i \, v_i lt.eq n \, u i eq.not v i \)$, indicating a road between cities $u_i$ and $v_i$.

The next line contains integer $k \( 0 lt.eq k lt.eq 10^5 \)$ --- the number of pairs of fools visiting each other.

The next $k$ lines each contain two space-separated numbers. Line $i \( i > 0 \)$ contains numbers $a_i \, b_i \( 1 lt.eq a_i \, b_i lt.eq n \)$.
This means the $(2i-1)$-th fool lives in city $a_i$ and visits the $2_i$-th
fool living in city $b_i$. The given pairs describe simple paths, since there
is only one simple path between each pair of cities.

*Output Format*

Output $n - 1$ integers separated by spaces. The $i$-th integer equals the
number of fools that travel along the $i$-th road. Roads are numbered
starting from 1 in the order they appear in the input.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`2 4`#linebreak()`2 5`#linebreak()`2`#linebreak()`1 4`#linebreak()`3 5`], [`2 1 1 1`],
)
