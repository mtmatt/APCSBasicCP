#import "../../template.typ": *

== 最短路徑
=== 概念
最短路徑應該是目前最有功能的演算法了，他在導航裡面頻繁地出現。

以下不同的演算法概念各不相同，甚至有動態規劃的(在後面的章節QQ)。
其中，Bellman-Ford與Dijkstra處理的是從某個確定的點出發，到所有點的最短距離。
而Floyd-Warshall則可以算出所有點對的最短路徑，不過當然就會花更多時間啦。

=== Bellman-Ford
==== 概念

我們需要先了解``鬆弛的概念''，鬆弛就是

尋找兩點的最短路徑時，最簡單的方法就是，先找一條，然後再找找看有沒有更短的。
最後留下最短的。

找更短的路徑並不困難。我們可以一直找一直找，直到找到最短路徑。

不過比較快的方法是找捷徑，就是盡可能縮短距離。

因此，在Bellmen-Ford演算法中，我們每一次都對每個邊確認
，他是否可以讓他要到的地方可以有更近的距離，這樣做過
n次之後，理論上就可以知道一個點到所有點的最短距離了。

也因此，這個算法的複雜度為$O \( n m \)$，其中n表示點的數量，
m表示邊的數量。

==== 實作

#code(title: [Bellmen-Ford 算法])[
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
==== 概念

這個演算法與前一個並不一樣。雖然同樣是鬆弛，可是如果所有的邊
權重皆為正，也就是不可能距離越走越短的話，我們可以使用資料結構
讓計算複雜度下降。

提出這樣的Greedy想法的就是Dijkstra。我們每一次都往距離最近的點走，
如此一來，因為我們邊的權重都是正的，所以不會有其他的邊可以更快走到那。

實作上，因為我們要找不斷找最近的，所以會需要一直求最小值，
所以我們可以使用`priority_queue`。

==== 實作

#code(title: [Dijkstra 算法])[
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
==== 概念

`dp[i][j][k]` 表示經過前 k 個點``鬆弛''後從 i 到 j 的最短距離。

那什麼是經過第k個點鬆弛呢？就是確認，如果從a到b先經過k會不會比較快。

因此經過一系列的通靈後，我們可以得知下式。

`dp[i][j][k] = min(dp[i][j][k-1],dp[i][k][k-1]+dp[k][j][k-1]);`

由於 dp 過程中只會用到 `dp[i][j][k-1]` ，所以可以重複利用陣列。
最後就像底下的dp式一樣可以只使用二維。

`dp[i][j] = min(dp[i][j],dp[i][k]+dp[k][j])`

==== 實作

實作上需要注意的有兩個，第一個是我們需要使用鄰接矩陣，第二個是
沒有邊的點要打標記，或是設為INF(超大的數字)。

#code(title: [Floyd-Warshall 算法])[
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

=== 範例與練習
==== Problem: CSES 1671 Shortest Routes I
*題目敘述*

有$n$個城市和$m$個城市之間的航班連接。你的任務是確定從Syrjälä到每個城市的最短路徑長度。

*輸入說明*

第一行有兩個整數$n$和$m$，表示城市數量和航班連接數量。城市編號為$1,2,...,n$，城市$1$為Syrjälä。

接下來的$m$行描述了航班連接。每行有三個整數$a, b$和$c$：一個航班從城市$a$開始，
到達城市$b$，航班長度為$c$。每個航班都是單程的。

你可以假設從Syrjälä到所有其他城市都是可行的。

$1 lt.eq n lt.eq 10^5$, $1 lt.eq m lt.eq 2 dot.op 10^5$, $1 lt.eq a \, b lt.eq n$, $1 lt.eq c lt.eq 10^9$.

*輸出說明*

輸出$n$個整數，表示從Syrjälä到城市$1,2, dots.h.c ,n$的最短路徑長度。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`3 4`#linebreak()`1 2 6`#linebreak()`1 3 2`#linebreak()`3 2 3`#linebreak()`1 3 4`], [`1`],
)
==== Problem: CSES 1672 Shortest Routes II
*題目敘述*

有$n$個城市和$m$條道路相連。你的任務是處理$q$個查詢，其中你需要確定兩個給定城市之間的最短路徑長度。

*輸入說明*

第一行有三個整數$n$，$m$和$q$，表示城市數量、道路數量和查詢數量。

接下來有$m$行描述道路。每行有三個整數$a$，$b$和$c$，表示城市$a$和城市$b$之間有一條長度為$c$的道路。所有道路都是雙向的。

最後有$q$行描述查詢。每行有兩個整數$a$和$b$，表示要求解的兩個城市之間的最短路徑長度。

$1 lt.eq n lt.eq 500$, $1 lt.eq m lt.eq n^2$, $1 lt.eq q lt.eq 10^5$,
$1 lt.eq a \, b lt.eq n$, $1 lt.eq c lt.eq 10^9$

*輸出說明*

對於每個查詢，輸出最短路徑的長度。如果不存在路徑，輸出$-1$。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`4 3 5`#linebreak()`1 2 5`#linebreak()`1 3 9`#linebreak()`1 2`#linebreak()`2 1`#linebreak()`1 3`#linebreak()`1 4`#linebreak()`3 2`], [`5`#linebreak()`5`#linebreak()`8`#linebreak()`-1`#linebreak()`3`],
)
==== Problem: CSES 1673 High Score
*題目敘述*

你玩一個遊戲，遊戲中有$n$個房間和$m$條通道。你的初始分數為0，每通過一條通道，你的分數增加$x$，其中$x$可以為正數或負數。你可以通過一條通道多次。

你的任務是從第一個房間走到第$n$個房間。你能獲得的最大分數是多少？

*輸入說明*

第一行有兩個整數$n$和$m$，表示房間數量和通道數量。房間編號為$1, 2, dots.h.c ,n$。

接下來有$m$行描述通道。每行有三個整數$a$，$b$和$x$，表示通道從房間$a$開始，
到房間$b$結束，通過該通道可以增加分數$x$。所有通道都是單向通道。

你可以假設從第一個房間到第$n$個房間是可行的。

$1 lt.eq n lt.eq 2500$, $1 lt.eq m lt.eq 5000$,
$1 lt.eq a \, b lt.eq n$, $- 10^9 lt.eq x lt.eq 10^9$

*輸出說明*

輸出一個整數，表示你能獲得的最大分數。如果你能獲得任意大的分數，輸出-1。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`4 5`#linebreak()`1 2 3`#linebreak()`2 4 -1`#linebreak()`1 3 -2`#linebreak()`3 4 7`#linebreak()`1 4 4`], [`5`],
)
==== Problem: TIOJ 1096 E.漢米頓的麻煩
*題目敘述*

轉圈圈捷運公司一向是以多樣性的路線，繞不完的圈圈，以及每條路線上搭配的行程而享譽國際。
不過也因為這樣，太多的路線交錯複雜，再也沒有人能夠分清楚哪一段是哪的路線，
以及總共有多少的圈圈。

轉圈圈捷運公司的董事長漢米頓，一直有想要作一件事情，就是想要把捷運路線上，
每一種圈圈的路線要坐上一遍，而他的這個計畫已經開始實施了。

但是，幾天之後他發現了他的想法幾乎不可能實現：他已經轉到快要吐出來的！
而且當他嘗試著要把所有的環狀路線全部都列出來，寫在他的記事本上的時候，他才發現這是一個很難的問題，
他根本不知道有多少條的圈圈路線！他列出了很多，也坐過了很多圈圈的路線，可是他沒有辦法知道說又沒有漏了哪一條環狀路線沒有坐過。

漢米頓花了很多的時間，才發現了這個問題很難，很難。不過漢米頓並不放棄，
雖然他以他一個人的力量沒有辦法做到，但是他想到了一個辦法！

轉圈圈捷運公司在近日內，會舉辦一個轉圈圈換獎品的活動，如果搭乘捷運的旅客所搭乘的路線，
起點和終點是同一個的話，就可以得到一份價值150元的獎品。當然，這條路線至少要有搭上捷運才算，
直接進站又出站的話可是不能算的！

轉圈圈捷運公司在計算車資的時候，是依照旅客從進站到出站的時間來計算的，如果坐了15分鐘的車，
那麼車費就會是15元。

漢米頓對於自己的想到的這個辦法很滿意，但是他還是有一點擔心：如果有人坐環狀路線的車資比150元還要少，
那公司可就虧大了dots.h.c 所以現在的他正在想辦法找找看有沒有哪一條環狀路線上的車資是會小於150元的。

看到漢米頓這麼煩惱，聰明的你應該想到好方法幫幫他了吧！可以寫個程式幫忙他找到在轉圈圈捷運公司的路線中，
所花費時間最少的一條環狀路線，要坐多久呢？

*輸入說明*

輸入檔中有許多組輸入，每組輸入的第一行有一個數字 $N$ （$1 lt.eq N lt.eq 100$），
代表總共有 $N$ 個捷運站。接下來有 $N$ 行，每行有 $N$ 個數字、以空白分隔，
第 $i$ 行的第 $j$ 個數字 $T_(i j)$ 代表編號 $i$ 的捷運站有一條路線到編號 $j$ 的捷運站，
車程 $T_(i j)$ 分鐘（$0 lt.eq T_(i j) lt.eq 1000$），如果這個數字是 $0$ 代表兩站之間沒有直接相連。
$N = 0$ 表示檔案結束。

*輸出說明*

對每組輸入輸出一行，包含一個數字，表示花費最短的環狀路線所花的時間。
如果找不到任何一條環狀路線，則輸出 $-1$。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`4`#linebreak()`0 0 2 0`#linebreak()`4 0 0 0`#linebreak()`0 3 0 1`#linebreak()`0 1 0 0`#linebreak()`0`], [`8`],
)
