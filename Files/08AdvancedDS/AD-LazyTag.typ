#import "../../template.typ": *

== 懶人標記
=== 概念
之前的線段樹只有單點修改的功能，而若需要區間加值的話則會很費時，
因此有人想到一個方法：若要修改的區間剛好完全包含線段樹上的某個區間的話，
就可以先在上面打一個標記。等到需要動到他下面的子區間再向下放，
因為我們一次最多在$O \( log n \)$個區間打上標記，
所以區間修改也可以從 $O \( n log \( n \) \)$ 進步到 $O \( log \( n \) \)$ 。

=== 實作
首先我們需要在node裡面增加一些東西，因為標記稱為Tag，所以以下程式碼中
的tag表示我們的標記。

#code(title: [懶人標記的node])[
  ```cpp
struct node{
    // value and tag
    int val,tag;

    // pointers to children
    node *rch,*lch;

    // constructor
    node(){
        val=tag=0;
        rch=lch=nullptr;
    }

    // constructor with initial value
    node(int v){
        val=v, tag=0;
        rch=lch=nullptr;
    }
};
  ```
]

接著，我們的node裡面會有一些函式，我以區間加值(將一段區間
都加上某個數)為例。

#code(title: [懶人標記的node])[
  ```cpp
struct node{
    // point update
    void modify(int p,int v,int lb=1,int rb=n){
        // base case: interval length is 1
        if(lb==rb){
            val=v;
            return;
        }

        // allocate child nodes if they don't exist
        if(!lch) lch=new node();
        if(!rch) rch=new node();

        push(lb,rb);

        // set mid to the midpoint of the interval, splitting into left and right
        // >>1 is equivalent to /2, but faster
        int mid=lb+rb>>1;

        if(p<=mid) lch->modify(p,v, lb ,mid);
        if(mid<p)  rch->modify(p,v,mid+1,rb);

        // remember what to do after updating a child?
        pull();
    }

    int query(int l,int r,int lb=1,int rb=n){
        if(l<=lb && rb<=r){
            return val;
        }

        push(lb,rb);

        int mid=lb+rb>>1;

        int ret=0;
        if(lch && l<=mid) ret+=lch->query(l,r, lb ,mid);
        if(rch && mid<r)  ret+=rch->query(l,r,mid+1,rb);

        pull();

        return ret;
    }

    // range addition
    void add(int l,int r,int v,int lb=1,int rb=n){
        // base case: current interval is completely inside the target range
        if(l<=lb && rb<=r){
            // since the interval is closed [lb,rb], we add 1 to the count
            val+=v*(rb-lb+1);
            tag+=v;
            return;
        }

        push(lb,rb);

        int mid=lb+rb>>1;

        int ret=0;
        if(lch && l<=mid) lch->add(l,r,v, lb ,mid);
        if(rch && mid<r)  rch->add(l,r,v,mid+1,rb);

        pull();
    }
};
  ```
]

另一種方式是用陣列，我們可以另外開一個陣列稱為tag。具體的程式
架構與上述的指標型線段樹大致相同，就留給各位自行練習了。

=== 範例與練習
==== 範例: TIOJ 1224 矩形覆蓋面積計算
*題目敘述*

給你很多平面上的矩形，請求出它們覆蓋的總表面積。

*輸入說明*

輸入檔案只包含一筆測試資料。

第一行包含一個正整數 $n$，表示矩形的數量 ($1 lt.eq n lt.eq 100 \, 000$)。

接下來的 $n$ 行，每行包含四個整數 $L \, R \, D \, U$
($0 lt.eq L < R lt.eq 1 \, 000 \, 000$；$0 lt.eq D < U lt.eq 1 \, 000 \, 000$)，
代表矩形的左、右、下、上四個邊界座標。

*輸出說明*

請輸出覆蓋的總面積。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`2`#linebreak()`1 10 1 10`#linebreak()`0 2 0 2`], [`84`],
)

==== 想法

想像有一條線從上往下(或從下往上)掃描，每個矩形的上邊表示進入，
下邊表示出來，我們可以藉由維護這個區間有多少地方是有被矩形覆蓋的
直到有所變化(進或出)，這所有區間長度總和，乘上上次有變化到這次有變化前高度
就是這一段的面積。

#figure(image("../Images/LazyTag1.png", width: 80.0%),
  caption: [
    矩形覆蓋面積示意圖
  ]
)

#figure(image("../Images/LazyTag2.png", width: 80.0%),
  caption: [
    第一個變化
  ]
)

#figure(image("../Images/LazyTag3.png", width: 80.0%),
  caption: [
    第二個變化
  ]
)

==== 實作

首先，我們需要一棵可以區間加值的線段樹。接著對所有的變化做排序，
最後一一計算分部的面積。因為這題比較特殊，所以我貼上完整的程式碼。

注意：因為我們只要查詢所有的和，所以我們可以使用跟節點的值就好。

#code(title: [矩形覆蓋面積題解])[
  ```cpp
#include<bits/stdc++.h>
using namespace std;

struct node{
    int ct=0,sum=0;
}seg[3050000];

struct line{
    int l,r,x,m;
    line(){
        l=r=x=0;
    }
    line(int a,int b,int c,int i){
        l=a;r=b;x=c;m=i;
    }
};
bool operator<(line a,line b){
    return a.x<b.x;
}

int n,MXN;
vector<line> lns;

void pull(int idx){
    seg[idx].sum=seg[idx*2].sum+seg[idx*2+1].sum;
}

void init(){
    MXN=1;
    while(MXN<1000010)
        MXN<<=1;
}

void add(int l,int r,int v,int lb=1,int rb=MXN,int idx=1){
    if(l<=lb && rb<=r){
        seg[idx].ct+=v;
        if(seg[idx].ct>0) seg[idx].sum=rb-lb+1;
        else pull(idx);
        return;
    }

    int mid=lb+rb>>1;
    if(l<=mid) add(l,r,v,lb,mid,idx*2);
    if(mid+1<=r) add(l,r,v,mid+1,rb,idx*2+1);

    if(seg[idx].ct>0) seg[idx].sum=rb-lb+1;
    else pull(idx);
}

int main(){
    ios::sync_with_stdio(0);cin.tie(0);

    cin>>n;
    for(int i=0;i<n;++i){
        int l,r,d,u;
        cin>>l>>r>>d>>u;
        lns.emplace_back(line(l+1,r,d,1));
        lns.emplace_back(line(l+1,r,u,-1));
    }
    sort(lns.begin(),lns.end());
    init();

    long long sum=0,pre=lns.front().x;
    for(auto ln:lns){
        if(ln.x != pre){
            sum+=(seg[1].sum)*(ln.x-pre);
            pre=ln.x;
        }
        add(ln.l,ln.r,ln.m);
    }
    sum+=(seg[1].sum)*(lns.back().x-pre);

    cout<<sum;
}
  ```
]
==== 問題: 洛谷P3870 【TJOI2009】開關
*題目敘述*

現有 $n$ 盞燈排成一排，從左到右依次編號為 $1$，$2$，……，$n$。然後依次執行 $m$ 項操作。

操作分為兩種：

+ 指定一個區間
  $\[ a \, b \]$，然後改變編號在這個區間內的燈的狀態(把開著的燈關上，關著的燈打開)。

+ 指定一個區間 $\[ a \, b \]$，要求你輸出這個區間內有多少盞燈是打開的。

燈在初始時都是關著的。

*輸入說明*

第一行有兩個整數 $n$ 和 $m$，分別表示燈的數目和操作的數目。

接下來有 $m$ 行，每行有三個整數，依次為：$c$、$a$、$b$。其中 $c$ 表示操作的種類。

+ 當 $c$ 的值為 $0$ 時，表示是第一種操作。

+ 當 $c$ 的值為 $1$ 時，表示是第二種操作。

$a$ 和 $b$ 則分別表示了操作區間的左右邊界。

$2 lt.eq n lt.eq 10^5$， $1 lt.eq m lt.eq 10^5$， $1 lt.eq a \, b lt.eq n$， $c in { 0 \, 1 }$

*輸出說明*

每當遇到第二種操作時，輸出一行，包含一個整數，表示此時在查詢的區間中打開的燈的數目。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`4 5`#linebreak()`0 1 2`#linebreak()`0 2 4`#linebreak()`1 2 3`#linebreak()`0 2 4`#linebreak()`1 1 4`], [`1`#linebreak()`2`],
)
==== 問題: 洛谷P1438 無聊的數列
*題目敘述*

無聊的 YYB 總喜歡搞出一些正常人無法搞出的東西。有一天，無聊的 YYB 想出了一道無聊的題：無聊的數列。。。（K峰：這題不是傻X題嗎）

維護一個數列 $a_i$，支持兩種操作：

`1 l r K D`：給出一個長度等於 $r - l + 1$ 的等差數列，
首項為 $K$，公差為 $D$，並將它對應加到 $\[ l \, r \]$ 範圍中的每一個數上。
即：令 $a_l = a_l + K \, a_(l + 1) = a_(l + 1) + K + D dots.h a_r = a_r + K + \( r - l \) times D$。

`2 p`：詢問序列的第 $p$ 個數的值 $a_p$。

*輸入說明*

第一行兩個整數數 $n,m$ 表示數列長度和操作個數。

第二行 $n$ 個整數，第 $i$ 個數表示 $a_i$。

接下來的 $m$ 行，每行先輸入一個整數 $o p t$。

若 $o p t = 1$ 則再輸入四個整數 $l med r med K med D$；

若 $o p t = 2$ 則再輸入一個整數 $p$。

$0 lt.eq n \, m lt.eq 10^5,-200 lt.eq a_i \, K \, D lt.eq 200, 1 lt.eq l lt.eq r lt.eq n, 1 lt.eq p lt.eq n$

*輸出說明*

對於每個詢問，一行一個整數表示答案。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`5 2`#linebreak()`1 2 3 4 5`#linebreak()`1 2 4 1 2`#linebreak()`2 3`], [`6`],
)
