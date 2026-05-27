#import "../../template.typ": *

== 最近共同祖先
=== 概念
考慮一顆有根樹，我們希望找到任何兩個節點的最近同祖先(又稱為LCA)。
我們以樹示意圖為例，將節點2定為根，我們希望找到節點5和8的最近共同祖先。
那麼最近共同祖先便是1。

我們可以很快的想到一個$O(n)$的方法找出任兩節點的最近共同祖先。
首先，我們先跑過一次DFS預處理每個節點到根的距離，接著，
如果需要查詢u和v的LCA，我們遵循幾個條件。

- 如果u離根的距離短，重複讓v與根的距離縮短，反之就讓u與根的距離縮短。

- 讓u,v與根的距離保持相等向上尋找。

- 如果找到同一個點就是正確的。

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

不過這樣的速度並不是很讓人滿意，有沒有辦法讓搜尋的速度提升呢，
答案是可以的，只需要犧牲一點點預處理的時間就可以了。

=== 倍增法
剛剛我們在找LCA的時候我們都是一個一個向上的，如果我們可以一次
跳很多步，是否就會快上許多呢？沒有錯，我們可以要建構從節點u向上
$1  ~  n$個節點是誰，在做二分搜，可是這樣預處理的時間將會是$O(n^2)$。
太慢了。所以我們退而求其次，建構u向上$1, 2, 4, dots, 2^k, dots, 2^{log_2(n)}$
步的節點。這樣會花費$O(n log(n))$的時間做預處理，也可以在$O(log(n))$的時間內
完成查詢的工作。

=== 實作
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

=== 範例與練習
==== Problem: 洛谷P3379 【模板】最近公共祖先(LCA)
*題目敘述*

給定一棵有根多叉樹，求指定兩個節點的最近公共祖先。

*輸入說明*

第一行包含三個正整數
$N, M, S$，分別表示樹的節點個數、詢問的個數和樹的根節點序號。

接下來 $N - 1$ 行，每行包含兩個正整數 $x, y$，表示節點 $x$ 和節點 $y$ 之間有一條直接連接的邊（保證可以構成樹）。

接下來 $M$ 行，每行包含兩個正整數 $a, b$，表示詢問節點 $a$ 和節點 $b$ 的最近公共祖先。

$100\%$ 的數據，$1 <= N, M <= 500000$，$1 <= x, y, a, b <= N$，不保證 $a \ne b$

*輸出說明*

輸出包含 $M$ 行，每行包含一個正整數，依次為每一個詢問的結果。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`5 5 4`#linebreak()`3 1`#linebreak()`2 4`#linebreak()`5 1`#linebreak()`1 4`#linebreak()`2 4`#linebreak()`3 2`#linebreak()`3 5`#linebreak()`1 2`#linebreak()`4 5`], [`4`#linebreak()`4`#linebreak()`1`#linebreak()`4`#linebreak()`4`],
)
==== Problem: CF 191 C Fools and Roads
*題目敘述*

他們說伯蘭德有兩個問題，愚蠢的人和道路。此外，伯蘭德有n個城市，由愚蠢的人居住，並由道路連接。伯蘭德的所有道路都是雙向的。
由於伯蘭德有很多愚蠢的人，所以每對城市之間都有一條路徑(否則愚蠢的人會生氣)。此外，每對城市之間最多只有一條簡單路徑(否則愚蠢的人會迷路)。

但這還不是伯蘭德的特點結束。在這個國家，愚蠢的人有時互相訪問，從而破壞了道路。愚蠢的人並不聰明，所以他們只使用簡單的路徑。

簡單路徑是通過每個伯蘭德城市不超過一次的路徑。

伯蘭德政府知道愚蠢的人使用的路徑。幫助政府計算每條道路上可以走的不同愚蠢的人數量。

愚蠢的人的路徑將在在輸入中給出說明。

*輸入說明*

第一行包含一個整數$n (2 <= n <= 10^5)$——城市的數量。

接下來的$n - 1$行，每行包含兩個以空格分隔的整數$u_i$, $v_i$
$(1 <= u_i, v_i <= n, u_i \ne v_i)$，表示城市$u_i$和$v_i$之間有一條連接的道路。

下一行包含整數$k (0 <= k <= 10^5)$——互相訪問的愚蠢人對數。

接下來的$k$行包含兩個以空格分隔的數字。第$i$行$(i > 0)$包含數字$a_i, b_i (1 <= a_i, b_i <= n)$。
這意味著第$(2i-1)$個愚蠢的人住在城市$a_i$，並訪問住在城市$b_i$的第$2_i$個愚蠢的人。
給定的數對描述了簡單的路徑，因為在每對城市之間只有一條簡單的路徑。

*輸出說明*

輸出$n - 1$個整數，數字應以空格分隔。第$i$個數字應該等於第$i$條道路上可以走的愚蠢的人數量。
道路從輸入中出現的順序開始編號，從1開始。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`5`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`2 4`#linebreak()`2 5`#linebreak()`2`#linebreak()`1 4`#linebreak()`3 5`], [`2 1 1 1`],
)
