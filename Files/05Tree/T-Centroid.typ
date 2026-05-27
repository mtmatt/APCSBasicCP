#import "../../template.typ": *

== Tree Centroid
=== Concept
The centroid of a tree is the node whose removal minimizes the maximum size
among all resulting subtrees.

In other words, when the centroid is used as the root, every subtree has size
no greater than half the total number of nodes.

To find the centroid, we can apply DP. First, pick any node as the root and
DFS downward. For each node, find the size of its largest subtree. Finally,
do not forget that if a node is treated as the root, all nodes above it become
its subtree as well, so those must also be considered.

=== Implementation
#code(title: [Tree Centroid])[
  ```cpp
#include<bits/stdc++.h>
using namespace std;
#define INF 1000000000

vector<int> child[100010];
// sz[x] is the subtree size of x, dp[x] is the largest subtree size below x.
int sz[100010],dp[100010],ans=-1,n,mn=INF;
// vt is the visited array, indicating whether a node has been visited.
bool vt[100010];

void dfs(int a){
    sz[a]=1;
    for(auto c:child[a]){
        if(!vt[c]){
            vt[c]=true;
            dfs(c);
            sz[a]+=sz[c];
            dp[a]=max(dp[a],sz[c]);
        }
    }
    dp[a]=max(dp[a],n-sz[a]);
    if(mn>dp[a]){
        mn=dp[a];
        ans=a;
    }else if(mn==dp[a] && ans>a){
        ans=a;
    }
}

int main(){
    ios::sync_with_stdio(0);cin.tie(0);

    int t;
    cin>>t;
    for(int iptNum=0;iptNum<t;iptNum++){
        mn=INF;
        for(int i=0;i<100010;i++){
            child[i].clear();
            sz[i]=0;
            dp[i]=0;
            vt[i]=false;
        }
        cin>>n;
        for(int i=1;i<n;i++){
            int c,p;
            cin>>p>>c;
            child[p].emplace_back(c);
            child[c].emplace_back(p);
        }
        dfs(0);
        cout<<ans<<"\n";
    }
    return 0;
}
  ```
]

=== Examples and Exercises
==== Problem: CF 708C Centroids
*Problem Statement*

You are given a tree with $n$ nodes. A node is called a centroid if, after
removing it, every connected component has size at most $n / 2$.

You may perform at most one edge replacement operation. An edge replacement
means removing one edge from the tree (keeping the corresponding nodes) and
then inserting a new edge (without adding new nodes) so that the result is
still a tree. You need to determine, for each node, whether it can become a
centroid via at most one edge replacement.

*Input Format*

The first line contains an integer $n \( 2 lt.eq n lt.eq 4 times 10^5 ）$ representing the number of nodes.
The next $n - 1$ lines each contain a pair of node indices $u_i$ and $v_i \( 1 lt.eq u_i \, v_i lt.eq n \)$ representing the endpoints of an edge.

*Output Format*

Output n integers. The i-th integer is 1 if node i can become a centroid via at most one edge replacement, and 0 otherwise.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`1 4`#linebreak()`1 5`], [`1 0 0 0 0`],
  [Sample Input 2], [Sample Output 2],
  [`3`#linebreak()`1 2`#linebreak()`2 3`], [`1 1 1`],
)

#block[
First find the centroid, then use its properties.

]
==== Problem: Luogu P1395 Meeting
*Problem Statement*

A village has $n$ residents. Their homes are connected by $n - 1$ paths, each
of length 1. The village chief plans to hold a meeting at one resident's home
and wants to choose a location that minimizes the total distance from all
residents to the meeting place. If multiple homes satisfy this condition,
choose the one with the smallest resident number.

*Input Format*

The first line contains an integer $n$ representing the number of residents.

The next $n - 1$ lines each contain two integers $a$ and $b$, indicating that
there is a path between resident $a$'s home and resident $b$'s home.

$n lt.eq 5 times 10^4$

*Output Format*

Output one line containing two integers $x$ and $y$. $x$ is the number of the
resident whose home is chosen as the meeting location. $y$ is the minimum total
distance from all residents to the meeting location.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`1 2`#linebreak()`2 3`#linebreak()`3 4`], [`2 4`],
)
