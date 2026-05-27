#import "../../template.typ": *

== Euler Tour on Trees
=== What is an Euler Tour
Generally speaking, an Euler tour refers to a path that traverses every edge
exactly once. However, trees clearly have no such path. So the Euler tour on a
tree refers to a path where every edge is traversed exactly twice. We can
record such a path using DFS.

=== Applications
Using this method together with data structures, LCA queries can also be
answered in $O \( log \( n \) \)$ time. In addition, there are other problems
that make use of this technique.

=== Construction
#code(title: [Euler Tour on Trees])[
  ```cpp
vector<int> g[100010] ;
vector<int> et ;
int in[100010], out[100010] ;

void dfs(int x, int p) {
    et.push_back(x) ;
    in[x] = et.size() - 1 ;
    for(auto i:g[x]) if(i != p) {
        dfs(i, x) ;
        et.push_back(x) ;
    }
    out[x] = et.size() - 1 ;
}
  ```
]

If you want to use this to solve LCA problems, you also need to store an extra
variable: the depth. The LCA of two nodes is then the position of the minimum
depth between the two nodes in the Euler tour.

=== Examples and Exercises
==== Problem: CF 620 E New Year Tree
*Problem Statement*

The New Year holidays are over, but Resha does not want to throw away the New
Year tree. He invited his best friends Kerim and Gural to help him redecorate
the New Year tree.

The New Year tree is an undirected tree with n vertices rooted at vertex 1.

You need to handle two types of queries:

+ Change the color of all vertices in the subtree of vertex v to color c.

+ Find the number of distinct colors in the subtree of vertex v.

*Input Format*

The first line contains two integers $n$ and $m$ $\( 1 lt.eq n \, m lt.eq 4 times 10^5 \)$
--- the number of vertices in the tree and the number of queries.

The second line contains $n$ integers $c_i$ $\( 1 lt.eq c_i lt.eq 60 \)$ --- the
color of the $i$-th vertex.

The next $n - 1$ lines each contain two integers $x_j$ and $y_j$
$\( 1 lt.eq x_j \, y_j lt.eq n \)$ --- the two endpoints of the $j$-th edge.
It is guaranteed the input forms a valid undirected tree.

The last $m$ lines contain the query descriptions. Each description begins
with an integer $t_k \( 1 lt.eq t_k lt.eq 2 \)$ --- the type of the $k$-th query.
For a type-1 query, two more integers $v_k$ and $c_k$
$\( 1 lt.eq v_k lt.eq n \, 1 lt.eq c_k lt.eq 60 \)$ follow --- the subtree rooted at
$v_k$ will be repainted with color $c_k$. For a type-2 query, one more integer
$v_k$ $\( 1 lt.eq v_k lt.eq n \)$ follows ---
find the number of distinct colors in the subtree of $v_k$.

*Output Format*

For each type-2 query, output a single integer $a$ ---
the number of distinct colors in the subtree of the given vertex.

Each number should be printed on a separate line in the order the queries
appear in the input.
