#import "../../template.typ": *

== Fundamentals
=== What is a Graph?
A graph $G$ consists of vertices $V$ and edges $E$, written as $G = \( V \, E \)$. Sounds complicated?

It's really just something that looks like this.

#figure(image("../Images/Graph1.png", width: 50.0%),
  caption: [
    Illustration of a "graph"
  ]
)

=== Useful Online Tool
#link("https://csacademy.com/app/graph_editor/")

The graphs it draws look like this.

#figure(image("../Images/Graph2.png", width: 50.0%),
  caption: [
  ]
)

=== Use Cases
So that's what a graph is — but what kinds of problems does it actually lead to?
==== Example: Basic Graph Problem
Given a directed graph G and a starting vertex s,

- Count the number of vertices reachable from s (not including s itself).

- Compute the sum of distances from s to each reachable vertex.

- Assume every edge has length 1.

- There may be multiple edges between the same pair of vertices.

- An edge's start and end vertices are not necessarily distinct.

=== Storing a Graph
==== Adjacency List

Since adjacency matrices are rarely needed in competitions, I'll cover adjacency lists first.

Simply put, we use an array of vectors to store the relationships between vertices.

#code(title: [Storing a Graph])[
  ```cpp
const int N=100010;
vector<int> g[N];
  ```
]

Here, g\[x\] holds all vertices reachable from x (note that g\[x\] is a vector).
To add an edge from a to b, there are two cases:

+ Directed graph: `g[a].push_back(b);`

+ Undirected graph, also add: `g[b].push_back(a);`

We do this because in an undirected graph, edges can be traversed in both directions — if a can reach b, then b can also reach a.

==== Adjacency Matrix

An adjacency matrix uses a `g[n][n]` array to represent the graph, where `g[a][b]>0` means
a can reach b. This representation is intuitive, but requires $O \( n^2 \)$ memory.
Compared to the $O \( n + m \)$ of the adjacency list, this is much higher — in competitions, constraints like $n lt.eq 10^5 \, #h(0em) m lt.eq 2 times 10^5$ are very common.

=== BFS (Breadth-First Search)
Visits vertices in order of the number of edges from the starting vertex. The implementation uses a simple data structure: a queue.

#code(title: [BFS on a Graph])[
  ```cpp
vector<int> g[N];
bool isv[N];

void BFS(int s){
    queue<int> q;
    q.push(s);

    while(!q.empty()){
        int now=q.front();
        q.pop();
        for(auto e:g[now]) if(!isv[e]){
            q.push(e);
            isv[e]=true;
        }
    }
}
  ```
]

However, to solve the example problem above, we need some extra bookkeeping.

#code(title: [Solution to the Basic Graph Problem])[
  ```cpp
struct info{
    int to,dis;
};

vector<int> g[N];
bool isv[N];

int bfs(int s){
    queue<info> q;
    q.push({s,0});

    int ret=0;

    while(!q.empty()){
        info now=q.front();
        q.pop();

        ret+=now.dis;

        for(auto e:g[now.to]) if(!isv[e]){
            q.push({e,now.dis+1});
            isv[e]=true;
        }
    }

    return ret;
}
  ```
]

=== DFS (Depth-First Search)
Unlike BFS, DFS keeps going as long as there is a path forward,
and only backtracks when it hits a dead end. This might sound complicated, but
the code is similar to tree DFS, so it's still quite straightforward.

#code(title: [Solution to the Basic Graph Problem])[
  ```cpp
vector<int> g[N];
bool isv[N];

void DFS(int n){
    for(auto u:g[n]) if(!isv[u]){
        isv[u]=true;
        DFS(u);
    }
}
  ```
]

Note that the isv marking must happen before the recursive DFS call; otherwise, if a cycle exists, the program will fall into an infinite loop.

Because DFS is noticeably easier to write, it is almost always used when DFS is applicable.

=== Examples and Practice
==== Example: AP325 P-7-2 Collecting Treasures by Car
*Problem Statement*

You are participating in a treasure-hunting game. You have a map with n treasure locations,
each holding some items of value. Since your team is the best,
you are guaranteed to collect all treasure at any location you reach.

On the map there are m roads in total, each connecting two treasure locations,
and every road is bidirectional.

At the start of the game, you may request a helicopter to transport your team to any treasure location.
You will also receive a car with plenty of fuel, but the helicopter can only take you once,
so you must decide where to start in order to maximize the total value of the treasure collected.

*Input Format*

The first line contains two positive integers n and m, representing the number of treasure locations and roads. Locations are numbered $0$ to $n - 1$.

The second line contains n
non-negative integers, each representing the treasure value at the corresponding location. Each location's treasure value does not exceed $100$.

The following m lines each contain two integers a and b, representing the two locations connected by a road.

n does not exceed $5 times 10^4$, m does not exceed $5 times 10^5$.

There may be multiple roads between the same pair of locations, and some roads may connect a location to itself.

*Output Format*

The maximum total treasure value obtainable.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7 6`#linebreak()`5 2 4 2 1 1 8`#linebreak()`5 1`#linebreak()`1 3`#linebreak()`1 4`#linebreak()`2 0`#linebreak()`2 0`#linebreak()`3 3`], [`9`],
)

#block[
In general, the graph given in a problem may not allow reaching every vertex from the starting point.
When this happens, we say the graph is disconnected; conversely, a graph where every vertex is reachable from the start is called a connected graph.

]
We can accumulate and return the total value during DFS, so our DFS is no longer void — it can return int
(or long long, etc.).

Since the graph may be disconnected, we need to check every vertex and find the maximum total sum among all connected components (i.e., each connected subgraph).

#code(title: [Solution to Collecting Treasures by Car])[
  ```cpp
int val[N];
vector<int> g[N];
bool isv[N];

int dfs(int n){
    int ret=val[n];
    for(int next:g[n]){
        if(!isv[next]){
            isv[next]=true;
            ret+=dfs(next);
        }
    }
    return ret;
}

int main(){
    // input

    int ans=0;

    for(int i=0;i<n;++i){
        if(!isv[i]){
            isv[i]=true;
            ans=max(ans,dfs(i));
        }
    }

    cout<<ans<<"\n";
}
  ```
]
==== Problem: CSES 1192 Counting Rooms
*Problem Statement*

Given a map, count the number of rooms. The map has $n times m$ cells,
each of which is either floor or wall. You can walk on floor tiles in the four cardinal directions (up, down, left, right),
and all positions reachable this way count as the same room.

*Input Format*

The first line contains two integers $n \, m$, followed by $n$ rows of $m$ characters. `#`
represents a wall, `.` represents floor.

*Output Format*

A single integer representing the number of rooms.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 8`#linebreak()`########`#linebreak()`#..#...#`#linebreak()`####.#.#`#linebreak()`#..#...#`#linebreak()`########`], [`3`],
)

#block[
You can use constant arrays to express relative directions, like this:

`const int dr[]{1,0,-1,0}, dc[]{0,1,0,-1};`

]
==== Problem: CSES 1193 Labyrinth
*Problem Statement*

Given a map, find a path from A to B. The map has $n times m$ cells,
each of which is either floor or wall. You can walk on floor tiles in the four cardinal directions.

*Input Format*

The first line contains two integers $n \, m$, followed by $n$ rows of $m$ characters. `#`
represents a wall, `.` represents floor, A is the start, and B is the destination.

*Output Format*

If a path exists, first print "YES"; otherwise print "NO".

If a path exists, print the length of the shortest path, followed by a description of the path — a string consisting of the characters L (left),
R (right), U (up), and D (down). Any valid answer is accepted.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 8`#linebreak()`########`#linebreak()`#.A#...#`#linebreak()`#.##.#B#`#linebreak()`#......#`#linebreak()`########`], [`YES`#linebreak()`9`#linebreak()`LDDRRRRRU`],
)
==== Problem: CSES 1666 Building Roads
*Problem Statement*

Given $n$ vertices and $m$ undirected edges, find the minimum number of edges needed to make the graph connected,
and provide a specific solution. Vertices are numbered $1 dots.h.c n$.

*Input Format*

The first line contains two integers $n \, m$, followed by $m$ lines each containing an edge $a_i \, b_i$.

There are no self-loops or multi-edges.

*Output Format*

The first line outputs the number of edges to add. Subsequent lines give the specific edges to add. If there are multiple valid answers,
any one of them is accepted.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 2`#linebreak()`1 2`#linebreak()`3 4`], [`1`#linebreak()`2 3`],
)
