#import "../../template.typ": *

== 樹重心
=== 概念
樹的重心就是拔除他後，形成的若干棵樹分別的節點數量中的最大值，會最小的那個節點。

也可以說，以重心為根後，所有子樹的大小都不超過總結點的一半。

如果我們想要知道樹重心在哪裡的話，我們可以應用DP技巧。首先，我們同樣是隨意找一個節點當作根，接著向下DFS。接著，對於每個節點，我們都找出它的最大子樹。最後，不要忘記，如果把它當作根節點，那它上面的所有節點都將會是他的子樹，所以還要考慮上面的所有節點。

=== 實作
#code(title: [樹重心])[
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

=== 範例與練習
==== Problem: CF 708C Centroids
*題目敘述*

給定一個由$n$個節點組成的樹。如果從樹中刪除該節點後，每個連通分量的大小都不超過$n / 2$，則該節點稱為重心。

現在，你可以進行最多一次的邊替換操作。邊替換是指從樹中刪除一條邊(保留相應的節點)，然後插入一條新的邊(不添加新的節點)，使得圖形仍然是一棵樹。你需要判斷每個節點是否可以透過最多一次的邊替換成為重心。

*輸入說明*

第一行包含一個整數$n \( 2 lt.eq n lt.eq 4 times 10^5 ）$，表示樹中的節點數量。
接下來的$n - 1$行，每行包含一對節點索引$u_i$和$v_i \( 1 lt.eq u_i \, v_i lt.eq n \)$，表示相應邊的兩個端點。

*輸出說明*

輸出n個整數，第i個整數等於1表示第i個節點可以透過最多一次的邊替換成為中心節點，等於0則表示不能。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`5`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`1 4`#linebreak()`1 5`], [`1 0 0 0 0`],
  [範例輸入 2], [範例輸出 2],
  [`3`#linebreak()`1 2`#linebreak()`2 3`], [`1 1 1`],
)

#tip[
先找出重心，再利用它的性質。
]
==== Problem: 洛谷P1395 會議
*題目敘述*

在一個村莊裡住著$n$個村民，這$n$個村民的家通過$n - 1$條路徑相連，每條路徑的長度為1。現在，村長計劃在其中一個村民的家裡舉辦一場會議，村長希望選擇一個村民的家作為會議地點，使得所有村民到會議地點的距離之和最小。如果有多個村民的家都滿足條件，則選擇村民編號最小的家作為會議地點。

*輸入說明*

第一行包含一個整數$n$，表示村民的數量。

接下來的$n - 1$行，每行包含兩個整數$a$和$b$，表示村民$a$的家和村民$b$的家之間存在一條路徑。

$n lt.eq 5 times 10^4$

*輸出說明*

輸出一行，包含兩個整數$x$和$y$。$x$表示會議地點所在的村民家的編號。$y$表示所有村民到會議地點的距離之和的最小值。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`4`#linebreak()`1 2`#linebreak()`2 3`#linebreak()`3 4`], [`2 4`],
)
