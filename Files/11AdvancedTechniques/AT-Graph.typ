== Advanced Graph Theory
=== DFS Tree
The DFS Tree is a way to analyze a graph. We run DFS on the graph
and classify all the edges.

#figure(image("../Images/AT1.png", width: 80.0%),
  caption: none
)

For an undirected graph, we can classify edges into two types:

- Tree Edge: the destination vertex is being visited for the first time during DFS.

- Back Edge: the destination vertex has *already* been visited during DFS.

For a directed graph, we can classify edges into four types:

- Tree Edge: the destination vertex is being visited for the first time during DFS.

- Back Edge: the destination is an ancestor of the source (smaller depth, and the common ancestor is one of the two vertices themselves).

- Forward Edge: the destination is a descendant of the source (greater depth, and the common ancestor is one of the two vertices themselves).

- Cross Edge: an edge between different subtrees (the common ancestor is *not* either of the two vertices).

#figure(image("../Images/AT2.png", width: 80.0%),
  caption: none
)

Several properties can be derived from the DFS Tree. For example, regarding cycles: if an edge is a Back Edge,
it definitely lies on a cycle passing through that edge. If it is a Cross Edge, it may or may not be on a cycle,
but any such cycle must pass through at least two Cross Edges or Back Edges.

=== Edge-Biconnected Components
Before introducing edge-biconnected components, we should first define edge-biconnectivity. We say vertices $a$ and $b$ are
edge-biconnected if removing any single edge from the graph does not disconnect $a$ from $b$.

Edge-biconnectivity satisfies transitivity: if $a$ and $k$ are edge-biconnected, and $k$ and $b$ are edge-biconnected,
then $a$ and $b$ are also edge-biconnected.

In this context, a new term emerges: a bridge (also called a cut edge) — an edge whose removal disconnects the graph.

To find all bridges, we need a new algorithm: Tarjan's algorithm.

#figure(image("../Images/AT3.png", width: 50.0%),
  caption: none
)

Side note: Many algorithms Tarjan invented are named after him, which can sometimes be confusing.

Concretely, we can use the DFS Tree. First, a Back Edge is never a bridge, because
all Tree Edges keep the remaining graph connected (within each connected component).

To determine whether a Tree Edge is a bridge, we need a new function: $l o w \( v \)$.

$ l o w \( v \) := "the minimum depth of any ancestor reachable from" v "without using" v"'s parent edge" $

The other function we already have is $d e p \( v \)$: the depth of $v$ in the tree, i.e., its distance from the root.

If $l o w \( v \) = d e p \( v \)$, then $v$'s parent edge is a bridge. $l o w \( v \)$ can be computed via DP.

==== Code: Edge-Biconnected Components

```
const int N=100010;
vector<int> g[N];
bool vis[N],bridge[N];
int low[N],dep[N];

void dfs(int x){
    vis[x]=true;
    low[x]=dep[x];
    for(auto i:g[x]){
        if(vis[i]){
            low[x]=min(low[x],dep[i]);
        }else{
            dep[i]=dep[x]+1;
            dfs(i);
            low[x]=min(low[x],low[i]);
        }
    }
    if(low[x]==dep[x]) bridge[x]=true;
}
```

=== Other Topics
Still under construction — please visit #link("https://hackmd.io/@Ccucumber12/HylySg2xF#")

#figure(image("../Images/AT4.png", width: 20.0%),
  caption: none
)
