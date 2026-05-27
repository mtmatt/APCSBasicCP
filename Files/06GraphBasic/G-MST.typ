#import "../../template.typ": *

== Minimum Spanning Tree
=== Concept
Minimum spanning trees are often used in road planning problems. Even if we don't directly see them in everyday life,
they definitely appear in practice — and they come up frequently in competitions.

So what is a minimum spanning tree? It is a subset of the graph's edge set that spans all vertices (forms a tree), and among all such subsets,
the one with the minimum total edge weight.

The two algorithms below differ conceptually, so I'll explain each separately.

=== Kruskal
==== Concept

We greedily add edges with the smallest weight. If adding an edge would create a cycle, we skip it. After processing all edges this way,
we will have found the minimum spanning tree.

Detecting whether adding an edge creates a cycle requires a DSU (Disjoint Set Union). We merge the connected components containing the two endpoints of each added edge —
this is exactly the operation DSU is designed for.

Sorting is the most expensive step, so the time complexity is $O \( m log \( n \) \)$.

==== Implementation

#code(title: [Kruskal Algorithm])[
  ```cpp
struct edge{
    int f,t,w;
};
bool operator<(edge a,edge b){
    return a.w<b.w;
}

int dsu[10010],rk[10010];
void init(int n){
    for(int i=0;i<=n;i++){
        dsu[i]=i;
        rk[i]=1;
    }
}

int find(int a){
    if(dsu[a]==a)
        return a;
    return find(dsu[a]);
}

bool same(int a,int b){
    return find(a)==find(b);
}

void uni(int a,int b){
    if(rk[find(a)]==rk[find(b)]){
        dsu[find(b)]=dsu[find(a)];
        rk[a]++;
    }else if(rk[find(a)]>rk[find(b)]){
        dsu[find(b)]=dsu[find(a)];
    }else{
        dsu[find(a)]=dsu[find(b)];
    }
}

int main(){
    // input

    sort(g.begin(),g.end());

    int ans=0,ct=0;

    init(n);
    for(auto e:g){
        if(!same(e.f,e.t)){
            uni(e.f,e.t);
            ct++;
            ans+=e.w;
        }
    }
}
  ```
]

=== Prim
Since I have never used Prim's algorithm, and both algorithms share the same time complexity of $O \( m log \( n \) \)$,

I will still give a brief overview of the concept. It is somewhat similar to Dijkstra, except that at each step we add
the edge closest to the set of vertices already determined.

As shown in the figure, the next vertex is the one closest to D or A. B is distance 9 from D and 7 from A, E is distance 15 from D,
and F is distance 6 from D. Therefore, F is closest to D or A, so vertex F and edge DF are highlighted in the figure.

#figure(image("../Images/Graph4.png", width: 50.0%),
  caption: [
  ]
)

We can also use a `priority_queue` to improve efficiency, giving the same $O \( m log \( n \) \)$ complexity.

=== Examples and Practice
==== Problem: Sprout OJ 734 Template Problem
==== Problem: Luogu P1194 Buying Gifts
*Problem Statement*

It's Mingming's birthday again, and Mingming wants to buy $B$ items. Coincidentally, all $B$
items cost $A$ dollars each.

However, the shop owner announces a promotion: if you buy item $I$ and then buy item
$J$, you only need to pay $K_(I \, J)$ dollars for the pair. Coincidentally, $K_(I \, J)$ equals
$K_(J \, I)$.

Mingming wants to know the minimum amount he has to spend.

*Input Format*

The first line contains two integers $A \, B$.

The following $B$ lines each contain $B$ numbers. The $J$-th number on the $I$-th line is $K_(I \, J)$.

It is guaranteed that $K_(I \, J) = K_(J \, I)$ and $K_(I \, I) = 0$.

In particular, if $K_(I \, J) = 0$, it means these two items do not trigger any discount.

$1 lt.eq B lt.eq 500 \, 0 lt.eq A \, K_(I \, J) lt.eq 1000$

*Output Format*

A single integer representing the minimum amount to spend.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 3`#linebreak()`0 2 4`#linebreak()`2 0 2`#linebreak()`4 2 0`], [`7`],
)
==== Problem: Luogu P1396 Rescue
*Problem Statement*

"Knock knock knock..." "Water meter inspection!" What a dedicated meter reader — hard to find these days!
Xiao Ming was so moved he opened the door $dots.h.c$

When his mother came home from work, the neighbors said Xiao Ming had been forcibly taken away by a group of strangers in a police car! His mother's experience told her that Xiao Ming was taken to district $t$, while she is in district $s$.

The city has $m$ avenues connecting $n$
districts. Each avenue connects two districts and has a congestion level.
Xiao Ming's mother is anxious but refuses to let the crowded streets ruin her elegant composure. Please help her plan a route from
$s$ to $t$ that minimizes the maximum congestion level along the path.

*Input Format*

The first line contains four space-separated values $n$, $m$, $s$, $t$ (see problem statement for meanings).

The following $m$ lines each contain three integers $u \, v \, w$, meaning there is an avenue connecting district $u$ and district
$v$ with congestion level $w$.

$1 lt.eq n lt.eq 10^4$, $1 lt.eq m lt.eq 2 times 10^4$, $w lt.eq 10^4$,
$1 lt.eq s \, t lt.eq n$. It is guaranteed that $t$ is reachable from $s$.

*Output Format*

Print a single integer representing the maximum congestion level.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 3 1 3`#linebreak()`1 2 2`#linebreak()`2 3 1`#linebreak()`1 3 3`], [`2`],
)
