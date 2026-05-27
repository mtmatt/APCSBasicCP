#import "../../template.typ": *

== Shortest Path
=== Concept
Shortest path is probably the most practically useful algorithm covered so far — it appears frequently in navigation systems.

The algorithms below differ significantly in their approaches, with one even using dynamic programming (covered in a later chapter).
Bellman-Ford and Dijkstra both find the shortest distance from a fixed source vertex to all other vertices.
Floyd-Warshall can compute shortest paths between all pairs of vertices, though it naturally takes more time.

=== Bellman-Ford
==== Concept

We first need to understand the concept of "relaxation." Relaxation means:

When searching for the shortest path between two vertices, the simplest approach is to find one path, then check whether there is a shorter one.
Keep the shorter one at the end.

Finding a shorter path is not difficult. We can keep searching until we find the shortest path.

A faster method is to look for shortcuts — shrinking the distance as much as possible.

In the Bellman-Ford algorithm, at every iteration we check each edge
to see whether it can reduce the distance to its destination. After doing this
n times, we will in theory know the shortest distance from the source to all other vertices.

This algorithm therefore has a time complexity of $O \( n m \)$, where n is the number of vertices
and m is the number of edges.

==== Implementation

#code(title: [Bellman-Ford Algorithm])[
  ```cpp
const int INF=0x3f3f3f3f;

int dis[N];
void Bellman_Ford(int s){
    fill(dis,dis+N,INF);
    dis[s]=0;

    while(true){
        bool update=false;
        for(auto e:es){
            if(dis[e.from]!=INF && dis[e.from]+e.dis<dis[e.to]){
                update=true;
                dis[e.to]=dis[e.from]+e.dis;
            }
        }

        if(!update){
            break;
        }
    }
}
  ```
]

=== Dijkstra
==== Concept

This algorithm differs from the previous one. Although it also uses relaxation, if all edge
weights are positive — meaning the distance cannot decrease as you travel further — we can use a data structure
to reduce the computational complexity.

The greedy insight behind Dijkstra is: always move to the nearest unvisited vertex.
Since all edge weights are positive, no other edge can provide a shorter path to that vertex.

In practice, since we repeatedly need to find the closest vertex, we need to continually find the minimum,
so we use a `priority_queue`.

==== Implementation

#code(title: [Dijkstra Algorithm])[
  ```cpp
#define to second
#define w first
#define INF 0x3f3f3f3f
using pii=pair<int,int>;

vector<pii> g[100010];

int main(){
    // input

    vector<int> dis(n+1,INF);
    priority_queue<pii,vector<pii>,greater<pii>> pq;

    dis[f]=0;
    for(auto i:g[f]){
        pq.push(make_pair(dis[f]+i.to,i.w));
    }

    for(int i=0;i<n-1;i++){
        auto u=pq.top();
        pq.pop();

        if(dis[u.to]!=INF) continue;

        dis[u.to]=u.w;
        for(auto j:g[u.to]){
            if(dis[j.w]==INF){
                pq.push(make_pair(dis[u.to]+j.to,j.w));
            }
        }
    }
}
  ```
]

=== Floyd-Warshall
==== Concept

`dp[i][j][k]` represents the shortest distance from i to j after "relaxing" through the first k vertices.

What does relaxing through the k-th vertex mean? It means checking whether going from a to b via k is faster.

After a series of derivations, we arrive at the following recurrence:

`dp[i][j][k] = min(dp[i][j][k-1],dp[i][k][k-1]+dp[k][j][k-1]);`

Since the dp only ever uses `dp[i][j][k-1]`, we can reuse the array.
The result is the two-dimensional recurrence below:

`dp[i][j] = min(dp[i][j],dp[i][k]+dp[k][j])`

==== Implementation

Two things to watch out for in the implementation: first, we need to use an adjacency matrix; second,
vertices with no edge between them must be marked or set to INF (a very large number).

#code(title: [Floyd-Warshall Algorithm])[
  ```cpp
void init(){
    for(int i=1;i<=n;++i)
        for(int j=1;j<=n;++j)
            dp[i][j]=INF;
}

void FloydWarshall(){
    for(int k=1;k<=n;++k){
        for(int i=1;i<=n;++i){
            for(int j=1;j<=n;++j){
                dp[i][j]=min(dp[i][j],dp[i][k]+dp[k][j]);
            }
        }
    }
}

// can also be simplified using a macro
#define REP(i,s,n) for(int i=(s);i<=(n);++i)

void FloydWarshall(){
    REP(k,1,n) REP(i,1,n) REP(j,1,n){
        dp[i][j]=min(dp[i][j],dp[i][k]+dp[k][j]);
    }
}
  ```
]

=== Examples and Practice
==== Problem: CSES 1671 Shortest Routes I
*Problem Statement*

There are $n$ cities and $m$ flight connections between them. Your task is to determine the length of the shortest path from Syrjälä to every other city.

*Input Format*

The first line contains two integers $n$ and $m$, representing the number of cities and flight connections. Cities are numbered $1 \, 2 \, . . . \, n$, and city $1$ is Syrjälä.

The following $m$ lines describe the flight connections. Each line has three integers $a \, b$ and $c$: a flight departs from city $a$,
arrives at city $b$, and has length $c$. All flights are one-way.

You may assume that it is possible to travel from Syrjälä to all other cities.

$1 lt.eq n lt.eq 10^5$, $1 lt.eq m lt.eq 2 dot.op 10^5$, $1 lt.eq a \, b lt.eq n$, $1 lt.eq c lt.eq 10^9$.

*Output Format*

Print $n$ integers representing the shortest path lengths from Syrjälä to cities $1 \, 2 \, dots.h.c \, n$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 4`#linebreak()`1 2 6`#linebreak()`1 3 2`#linebreak()`3 2 3`#linebreak()`1 3 4`], [`1`],
)
==== Problem: CSES 1672 Shortest Routes II
*Problem Statement*

There are $n$ cities connected by $m$ roads. Your task is to answer $q$ queries, each asking for the shortest path length between two given cities.

*Input Format*

The first line contains three integers $n$, $m$, and $q$, representing the number of cities, roads, and queries.

The following $m$ lines describe the roads. Each line has three integers $a$, $b$, and $c$, meaning there is a road of length $c$ between city $a$ and city $b$. All roads are bidirectional.

The final $q$ lines describe the queries. Each line has two integers $a$ and $b$, asking for the shortest path length between those two cities.

$1 lt.eq n lt.eq 500$, $1 lt.eq m lt.eq n^2$, $1 lt.eq q lt.eq 10^5$,
$1 lt.eq a \, b lt.eq n$, $1 lt.eq c lt.eq 10^9$

*Output Format*

For each query, output the shortest path length. If no path exists, output $- 1$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 3 5`#linebreak()`1 2 5`#linebreak()`1 3 9`#linebreak()`1 2`#linebreak()`2 1`#linebreak()`1 3`#linebreak()`1 4`#linebreak()`3 2`], [`5`#linebreak()`5`#linebreak()`8`#linebreak()`-1`#linebreak()`3`],
)
==== Problem: CSES 1673 High Score
*Problem Statement*

You are playing a game with $n$ rooms and $m$ tunnels. Your score starts at 0, and each time you traverse a tunnel your score increases by $x$, where $x$ can be positive or negative. You may traverse a tunnel multiple times.

Your task is to travel from room 1 to room $n$. What is the maximum score you can achieve?

*Input Format*

The first line contains two integers $n$ and $m$, representing the number of rooms and tunnels. Rooms are numbered $1 \, 2 \, dots.h.c \, n$.

The following $m$ lines describe the tunnels. Each line has three integers $a$, $b$, and $x$, meaning a tunnel goes from room $a$
to room $b$ and increases your score by $x$. All tunnels are one-way.

You may assume it is possible to travel from room 1 to room $n$.

$1 lt.eq n lt.eq 2500$, $1 lt.eq m lt.eq 5000$,
$1 lt.eq a \, b lt.eq n$, $- 10^9 lt.eq x lt.eq 10^9$

*Output Format*

Print a single integer representing the maximum score you can achieve. If you can earn an arbitrarily large score, print -1.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 5`#linebreak()`1 2 3`#linebreak()`2 4 -1`#linebreak()`1 3 -2`#linebreak()`3 4 7`#linebreak()`1 4 4`], [`5`],
)
==== Problem: TIOJ 1096 E. Hamilton's Trouble
*Problem Statement*

The Roundabout Transit Company has always been internationally renowned for its diverse routes, endless loops, and the itineraries on each line.
However, precisely because of this, the sheer number of crisscrossing routes means nobody can keep track of which segment belongs to which line
or how many loops exist in total.

The chairman of the Roundabout Transit Company, Hamilton, has long wanted to ride every circular route on the network at least once, and he has already begun doing so.

But a few days in he realized his dream is nearly impossible: he is almost dizzy from all the looping!
And when he tried to list every circular route in his notebook, he found that this was an extremely hard problem —
he had no idea how many loops there were. He had listed many and ridden many, but he couldn't know whether he had missed any.

After a great deal of effort, Hamilton discovered that this problem is very, very hard. Yet he did not give up;
even though he couldn't solve it alone, he came up with an idea!

The Roundabout Transit Company is soon hosting a special event: Ride a Loop, Win a Prize!
If a passenger rides a route where the starting station and ending station are the same, they win a prize worth 150 dollars.
Of course, the passenger must actually board a train — walking in and out of a station without boarding doesn't count!

The transit company charges based on the time a passenger spends from boarding to alighting — 15 minutes of riding costs 15 dollars.

Hamilton is pleased with his idea, but he has one concern: if someone rides a circular route that costs less than 150 dollars,
the company would lose money $dots.h.c$ So he is now trying to find out whether any circular route has a total fare below 150 dollars.

Seeing Hamilton so worried, surely you — clever as you are — have already thought of a way to help him!
Can you write a program to find the shortest circular route on the Roundabout Transit Company's network?

*Input Format*

The input contains many groups. Each group starts with a number $N$
($1 lt.eq N lt.eq 100$) representing the total number of stations. The following $N$
lines each have $N$ space-separated numbers. The $j$-th number on the $i$-th line, $T_(i j)$,
means there is a direct route from station $i$ to station $j$ with a travel time of $T_(i j)$
minutes ($0 lt.eq T_(i j) lt.eq 1000$). If the number is $0$,
there is no direct connection between those two stations. $N = 0$ marks the end of the input.

*Output Format*

For each group, output one line containing a single number representing the time of the shortest circular route.
If no circular route exists, output $- 1$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`0 0 2 0`#linebreak()`4 0 0 0`#linebreak()`0 3 0 1`#linebreak()`0 1 0 0`#linebreak()`0`], [`8`],
)
