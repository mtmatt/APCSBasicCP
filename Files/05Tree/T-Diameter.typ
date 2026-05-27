#import "../../template.typ": *

== Tree Diameter
=== Concept
The tree diameter is the longest distance in the tree. For example, in the
tree diagram shown earlier, the diameter is 5, going from node 0 all the way
to node 8.

To find the tree diameter, there are two methods: two DFS passes and dynamic
programming. If you do not yet know what dynamic programming is, it is enough
to know that by storing extra information in arrays, you can find the tree
diameter.

=== Two DFS Passes
The two-DFS approach works when edge weights are non-negative. We start by
picking any node $n$.

+ Find the node u farthest from n.

+ Then find the node v farthest from u.

After this, $u arrow.r v$ is one of the diameters of the tree. During the DFS
we maintain distances along the way, so the calculation is complete after the
second DFS.

#code(title: [Two DFS Passes])[
  ```cpp
struct pii{
    int mx,node;
};

pii dfs(int n,int p,int dis){
    pii ret={dis,n};
    for(auto u:g[n]) if(u.to!=p){
        pii tp=dfs(u.to,n,dis+u.dis);
        if(tp.mx>ret.mx){
            ret=tp;
        }
    }
    return ret;
}

int main(){
    // input
    pii a=dfs(1);
    pii b=dfs(a.node);

    cout<<b.mx<<"\n";
}
  ```
]

=== Tree DP
We maintain two arrays, mx and smx, storing the longest and the
(non-strictly) second longest values respectively. Using the tree diagram as
an example, set node 2 as the root and recurse downward with DFS. Looking at
node 1, its children are nodes 5, 6, and 7, where node 6 also has node 8 as a
child. So the maximum depths below nodes 5, 6, and 7 are 0, 1, and 0 respectively.

We can then connect the longest and second-longest edges through node 1 as a
bridge. Doing this for all nodes gives us the diameter.

#code(title: [Tree Diameter DP Algorithm])[
  ```cpp
#define pii pair<int,int>
#define to first
#define dis second
const int INF=0x3f3f3f3f;

vector<pii> g[500010];
int mx[500010],smx[500010],ans=-INF;

void dfs(int x,int p){
    if(g[x].size()<=1) mx[x]=smx[x]=0;
    else mx[x]=smx[x]=-INF;
    for(auto i:g[x]) if(i.to!=p) {
        dfs(i.to,x);
        if(mx[x]<mx[i.to]+i.dis){
            smx[x]=mx[x];
            mx[x]=mx[i.to]+i.dis;
        }else if(smx[x]<mx[i.to]+i.dis){
            smx[x]=mx[i.to]+i.dis;
        }
    }
    ans=max(ans,mx[x]+smx[x]);
}

int main(){
    // input
    dfs(1,0);
    cout<<ans;
}
  ```
]

=== Examples and Exercises
Luogu P3304 \[SDOI2013\] Diameter

*Problem Statement*

Xiao Q recently learned some graph theory. According to the textbook, the
following definitions apply. Tree: an acyclic connected undirected graph where
every edge has a positive integer weight representing its length. A tree with
$N$ nodes has exactly $N - 1$ edges.

Path: in a tree, there is at most one simple path between any two nodes. We
use $d i s \( a \, b \)$ to denote the sum of edge lengths on the path between
nodes $a$ and $b$. We call $d i s \( a \, b \)$ the distance between nodes
$a \, b$.

Diameter: the longest path in a tree is called its diameter. A tree may have
more than one diameter.

Xiao Q wants to know, for a given tree, what is the length of the diameter,
and how many edges are shared by all diameters.

*Input Format*

The first line contains an integer $N$ representing the number of nodes. The
next $N - 1$ lines each contain three integers $a \, b \, c$ indicating an
undirected edge of length $c$ between nodes $a$ and $b$.

$2 lt.eq N lt.eq 200000$, all node numbers are in the range $1 dots.h.c N$, and edge weights are $lt.eq 10^9$.

*Output Format*

Two lines. The first line contains an integer representing the diameter length.
The second line contains an integer representing the number of edges shared by
all diameters.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6`#linebreak()`3 1 1000`#linebreak()`1 4 10`#linebreak()`4 2 100`#linebreak()`4 5 50`#linebreak()`4 6 100`], [`1110`#linebreak()`2`],
)
==== Problem: Luogu P6722 "MCOI-01" Village
*Problem Statement*

Today, the adorable and kind 0x3 Nyan-chan rode a pony to a village.

"Hey, the layout of this village..." "Looks like the place I used to play Ciste qwq"

0x3 Nyan-chan has a map with information about the village. She needs to
determine whether Ciste has a solution based on the map.

Note: Ciste is a treasure map game from the anime *Is the Order a Rabbit?*.

The village is simplified as an undirected connected graph with $n$ nodes
(numbered $1$ to $n$) and $n - 1$ edges.

0x3 Nyan-chan believes the information of this undirected graph is related to
a new graph satisfying the following conditions:

The new graph has the same node set as the original graph. In the new graph,
there is an undirected edge between node $u$ and node $v$ if and only if
$d i s \( u \, v \) gt.eq k$ in the original graph ($k$ is a given constant,
$d i s \( u \, v \)$ denotes the shortest path length from node $u$ to node $v$).
0x3 Nyan-chan also believes that if this "new graph" is a bipartite graph,
then Ciste has a solution; otherwise it does not. (If you do not know what a
bipartite graph is, please refer to the hint.)

Please determine whether Ciste has a solution.

*Input Format*

The first line contains a positive integer $T$ representing $T$ test cases.
For each test case, the first line contains two positive integers $n$ and $k$.
The next $n - 1$ lines each contain three positive integers $x$, $y$, and $v$,
indicating an undirected edge of weight $v$ between nodes $x$ and $y$.
The input is guaranteed to be valid.

$n lt.eq 10^5$, $T lt.eq 10$, $v lt.eq 1000$, $k lt.eq 1000000$

*Output Format*

For each test case, output one line: "Yes" if Ciste has a solution, otherwise
output "Baka Chino".

#block[
A bipartite graph (also called a two-partite graph) is a special model in
graph theory. Let $G = \( V \, E \)$ be an undirected graph. If the vertex
set $V$ can be partitioned into two disjoint subsets $\( A \, B \)$, and
every edge $\( i \, j \)$ in the graph has its two endpoints $i$ and $j$
belonging to these two different subsets $\( i in A \, j in B \)$, then $G$
is called a bipartite graph.

]
==== Problem: Implement an algorithm to find the second longest tree diameter.
