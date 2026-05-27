#import "../../template.typ": *

== Basic Knowledge
=== What is a Tree
A tree is a connected graph with no cycles and no self-loops. Therefore,
a tree with $n$ nodes has exactly $n - 1$ edges. Removing any edge will
split it into two trees, and adding any edge will create a cycle.

Any two nodes in a tree have a unique path between them, so we have the
opportunity to find path lengths in $O \( log \( n \) \)$ time. We can also
develop efficient algorithms tailored to trees.

Nodes connected to only one edge are called leaf nodes. If a root exists,
the root node is still called the root regardless of how many edges it connects to.

#figure(image("../Images/Tree.png", width: 80.0%),
  caption: [
    Tree diagram
  ]
)

=== Data Storage
Generally, trees are stored the same way as graphs, primarily using adjacency
lists. However, due to the properties of trees, for a rooted tree we can use
an array where each node stores its parent node. If edges have weights, an
edge struct can be defined separately.

#code(title: [Tree Storage])[
  ```cpp
const int N=100010;
struct edge{
    int to,dis;// or w, c, etc.
};

vector<int> g[N];
vector<edge> g[N];
int p[N];// stores the parent
  ```
]

=== Tree Traversal
Two types of search can be used on trees, similar to graphs: Depth-First
Search (DFS) and Breadth-First Search (BFS).

Both DFS and BFS require rooting the tree, i.e., deciding which node is the
root. If the problem does not specify, you can simply choose 0 or 1.

The following examples use an unweighted graph.

#code(title: [DFS in Tree])[
  ```cpp
void dfs(int now,int parent){
    for(auto next:g[now]) if(next!=parent){
        dfs(next,now);
    }
}
  ```
]

#code(title: [BFS in Tree])[
  ```cpp
bool isv[N];
void bfs(int root){
    queue<int> nodes;
    nodes.push(root);
    while(!nodes.empty()){// can also use nodes.size()
        int now=nodes.front();
        nodes.pop();
        // do something below

        for(auto next:g[now]) if(!isv[next]){
            isv[next]=true;
            nodes.push(next);
        }
    }
}
  ```
]

On trees, we almost always use DFS, because both DFS and BFS visit all nodes,
but DFS requires less code — in short, it is the lazy choice.

=== Examples and Exercises
==== Example: Luogu P5908 Cat and Penguins
*Problem Statement*

A kingdom has $n$ residential areas connected by $n - 1$
roads. It is guaranteed that every residential area can reach every other one,
and every road has length $1$.

Except for residential area $1$, each residential area is home to a penguin.
One day a cat sets out from residential area $1$ and wants to visit some
penguins. However, the cat is very lazy and will only visit penguins that are
within distance $d$.

Since the cat is very lazy, please tell it how many penguins it can visit.

*Input Format*

The first line contains two integers $n \, d$ as described above.

Starting from the second line, there are $n - 1$ lines, each containing two
integers $u \, v$ indicating there is a road between residential areas $u$ and
$v$.

*Output Format*

A single integer indicating how many penguins the cat can visit.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 1`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`2 4`#linebreak()`3 5`], [`2`],
)

We can add a parameter dis to the dfs function to track the distance traveled so far.

#code(title: [Cat and Penguins Solution])[
  ```cpp
int d;
int dfs(int now,int parent,int dis=0){
    if(dis>d) return 0;

    int ret=0;
    if(now!=1) ret=1;

    for(auto next:g[now]) if(next!=parent){
        ret+=dfs(next,now,dis+1);
    }

    return ret;
}

int main(){
    // input
    dfs(1,1,0);
}
  ```
]
==== Problem: CF 1676 G White-Black Balanced Subtrees
*Problem Statement*

You are given a rooted tree of $n$ nodes numbered from $1$ to $n$,
with root $1$. There is also a string s representing the color of each node:
if $s_i = B$, node $i$ is black; if $s_i = W$, node $i$ is white.

A subtree of the tree is called balanced if the number of white nodes equals
the number of black nodes. Count the number of balanced subtrees.

A tree is an acyclic connected undirected graph. A rooted tree has a designated
node called the root. In this problem, all trees have root 1.

The tree is specified by a parent array $a_2 \, dots.h.c \, a_n$ of $n - 1$ numbers:
for all $i = 2 \, dots.h.c \, n$, $a_i$ is the parent of node $i$. The parent of
node $u$ is the next node on the simple path from $u$ to the root.

The subtree of node $u$ is the set of all nodes whose simple path to the root
passes through $u$. Note that a node is included in its own subtree, and the
subtree of the root is the entire tree.

*Input Format*

The first line of input contains an integer $t \( 1 lt.eq t lt.eq 10^4 \)$ --- the number of test cases.

The first line of each test case contains an integer $n \( 2 lt.eq n lt.eq 4000 \)$ --- the number of nodes in the tree.

The second line of each test case contains $n - 1$ integers $a_2 \, dots.h.c \, a_n （ 1 lt.eq a i < i ）$ --- the parents of nodes $2 \, dots.h.c \, n$.

The third line of each test case contains a string s of length n consisting of characters B and W --- the colors of the tree.

It is guaranteed that the sum of all $n$ values across all test cases does not exceed $2 times 10^5$.

*Output Format*

For each test case, output a single integer --- the number of balanced subtrees.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`7`#linebreak()`1 1 2 3 3 5`#linebreak()`WBBWWBW`#linebreak()`2`#linebreak()`1`#linebreak()`BW`#linebreak()`8`#linebreak()`1 2 3 4 5 6 7`#linebreak()`BWBWBWBW`], [`2`#linebreak()`1`#linebreak()`4`],
)
==== Problem: CF 115 A Party
*Problem Statement*

A company has $n$ employees, numbered $1$ to $n$. Each employee may have no
direct manager, or exactly one different employee as their direct manager.
Employee $A$ is called a superior of employee $B$ if one of the following
conditions holds:

Employee $A$ is the direct manager of employee $B$. Employee $B$ has a direct
manager employee $C$, and employee $A$ is a superior of employee $C$.
The company has no management cycles, i.e., no employee is a superior of their
own direct manager.

Today the company will hold a party. This involves dividing all $n$ employees
into groups: every employee must belong to exactly one group. Furthermore,
within any group, there cannot be two employees $A$ and $B$ such that $A$ is
a superior of $B$.

What is the minimum number of groups needed?

*Input Format*

The first line contains integer $n \( 1 lt.eq n lt.eq 2000 \)$ --- the number of employees.

The next $n$ lines each contain an integer
$p_i \( 1 lt.eq p_i lt.eq n #h(0em) or #h(0em) p_i = - 1 \)$. Each
$p_i$ is the direct manager of employee $i$. If $p_i$ is $- 1$, employee $i$
has no direct manager.

It is guaranteed that no employee is their own direct manager
$\( p_i eq.not i \)$, and there are no management cycles.

*Output Format*

Output a single integer representing the minimum number of groups formed at the party.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`-1`#linebreak()`1`#linebreak()`2`#linebreak()`1`#linebreak()`-1`], [`3`],
)

#block[
A graph containing multiple trees like this is typically called a forest.

]
