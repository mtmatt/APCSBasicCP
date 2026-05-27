#import "../../template.typ": *

== 線段樹
競賽上的版本。

=== 用法與概念

線段樹除了可以用來快速解區間和問題，還可以用來執行許多與區間有關的操作。建構區間方式大致上如圖。

#align(center)[#image("../Images/SEG.png", width: 100%)]

每個區間視情況放不同的數值，例如：最大/小，或是區間總和等。

接著，每個區間就都可以分為$O(log((n)))$個區間，例如`2-7`可以分為`2, 3-4, 5-6, 7`。

#align(center)[#image("../Images/SEG2.png", width: 100%)]

查詢時皆以最大區間為出發點，如圖就會是從`1-8`這個區間開始，如果要查詢的區間是`2-7`。因為`1-8`這個區間並沒有完全包含`2-7`，因此需要往下遞迴，分成`1-4`和`5-8`再次查詢。

接著，因為`1-4`和`5-8`仍然沒有完全被`2-7`包含，因此要再次遞迴，這次是分解成`1-2`,`3-4`,`5-6`以及`7-8`。

這次`3-4`和`5-6`都有被完全包含，因此可以直接回傳這個區間的值。而`1-2`和`7-8`還是沒有。所以這兩個區間還要再次向下查詢。

查詢時最重要的是，若區間完全被包含就直接回傳，若完全沒被包含就不往那邊搜尋，否則再將區間分成兩塊向下遞迴。

=== 實作

可以發現他是一顆二元樹，於是我們有兩種做法：指標型與陣列型。以下實作以區間總和為範例。

*陣列型*

#tip[
設根節點idx為1，在完滿二元樹中，左子樹就會是 $"idx" times 2$，右子樹就是 $"idx" times 2+1$。
]

#code(title: [Array-based Segment Tree])[
```cpp
#include<bits/stdc++.h>
using namespace std;

const int N=100010;

int a[N];
// The size of array seg is recommended to be N*4;
// otherwise you need to know the smallest power of 2 greater than N in advance.
// 131072 -> 262144, so opening 262200 is sufficient
int seg[N*4];
int n,MXN=1;

// Unlike the pointer-based approach, the array-based approach can be built in O(n)
void build(int lb=1,int rb=MXN,int idx=1){
    // Base case: interval length is 1
    if(lb==rb) return;

    // Set mid as the midpoint of the interval, splitting into left and right halves
    // >>1 is equivalent to /2 but slightly faster
    int mid=lb+rb>>1;

    // idx*2   is the left subtree
    // idx*2+1 is the right subtree
    build(lb,mid,idx*2);
    build(mid+1,rb,idx*2+1);

    seg[idx]=seg[idx*2]+seg[idx*2+1];
}

void init(){
    // Make the length a power of 2
    while(MXN<n) MXN<<=1;
    // Zero out
    for(int i=MXN+1;i<MXN*2;i++) seg[i]=0;
    // Initialize with the array contents
    for(int i=1;i<=n;++i) seg[MXN+i-1]=a[i];
    // Build all nodes
    build();
}

void modify(int x,int k){
    // This part also differs from the pointer-based approach:
    // the array allows direct modification by coordinate
    x=x+MXN-1;
    seg[x]=k;

    // Update nodes upward
    while(x>1){
        x>>=1;
        seg[x]=seg[x*2]+seg[x*2+1];
    }
}

int query(int l,int r,int lb=1,int rb=MXN,int idx=1){
    // Base case: current interval is fully within the query range
    if(l<=lb && rb<=r) return seg[idx];
    // Set mid as the midpoint of the interval, splitting into left and right halves
    // >>1 is equivalent to /2 but slightly faster
    int mid=lb+rb>>1;

    int ret=0;
    if(l<=mid)   ret+=query(l,r, lb ,mid,idx*2);
    if(r>=mid+1) ret+=query(l,r,mid+1,rb,idx*2+1);

    return ret;
}

int main(){
    ios::sync_with_stdio(0);cin.tie(0);

    cin>>n;
    for(int i=1;i<=n;++i) cin>>a[i];
    // Don't forget to call init()
    init();
}
```
]

*指標型*

#code(title: [Pointer-based Segment Tree])[
```cpp
#include<bits/stdc++.h>
using namespace std;

int n;

struct node{
    // value
    int val;
    // pointers to left and right subtrees
    node *rch,*lch;
    // default constructor
    node(){
        val=0;
        rch=lch=nullptr;
    }
    // constructor with initial value
    node(int v){
        val=v;
        rch=lch=nullptr;
    }
    // When the left or right subtree changes, recalculate the parent node's value
    void pull(){
        // Zero out
        val=0;
        // Must have left/right subtrees before accessing them
        // if(l) is equivalent to if(l!=nullptr)
        if(lch) val+=lch->val;
        if(rch) val+=rch->val;
    }
    // Point update
    void modify(int p,int v,int lb=1,int rb=n){
        // Base case: interval length is 1
        if(lb==rb){
            val=v;
            return;
        }
        // If left/right subtree nodes do not exist, create new ones
        if(!lch) lch=new node();
        if(!rch) rch=new node();
        // Set mid as the midpoint of the interval, splitting into left and right halves
        // >>1 is equivalent to /2 but much faster
        int mid=lb+rb>>1;
        // Go left if target is in left half, right otherwise
        if(p<=mid) lch->modify(p,v, lb ,mid);
        if(mid<p)  rch->modify(p,v,mid+1,rb);
        // Remember what to do after modifying the subtree?
        pull();
    }

    int query(int l,int r,int lb=1,int rb=n){
        // Base case: current interval is fully within the query range
        if(l<=lb && rb<=r){
            return val;
        }
        // Same as modify
        int mid=lb+rb>>1;

        int ret=0;
        if(lch && l<=mid) ret+=lch->query(l,r, lb ,mid);
        if(rch && mid<r)  ret+=rch->query(l,r,mid+1,rb);
        // For safety
        pull();
        return ret;
    }
};

node *rt=new node();//root
```
]

=== 範例與練習
==== Problem: ZJe409 Segment Tree

*題目敘述*

你需要使用線段樹支援兩種操作。

+ 將 $A[x]$ 的值更新為 $y$
+ 要查詢 $A[X]$-$A[Y]$ 之中最大值`maxA`及最小值`minA`的差


==== Problem: Tactical Database (110 Yizhong CS Club Internal Contest, Problem F)

*題目敘述*

要求能在一個陣列中做以下操作。

+ 搜尋區間和
+ 搜尋區間最大和最小值
+ 單點加減值


*輸入說明*

輸入第一行有一個數字 $n, q$ ，下一行有 $n$ 個數字，緊接著有 $q$ 筆操作，可能為以下五種。

+ 搜尋區間和 `find sum` $(l)$ $(r)$
+ 搜尋區間最大和最小值 `find` $max/min (l)$ $(r)$
+ 單點加減值 `plus/minus` (position) $(k)$


相鄰數字間以空白隔開。
$n, q <= 100000 , a[i] <= 100000$


*輸出說明*

對於每個搜尋指令做出回答。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`7 10`#linebreak()`1 2 3 4 5 6 7`#linebreak()`find max 2 5`#linebreak()`find min 1 4`#linebreak()`minus 3 1`#linebreak()`plus 2 4`#linebreak()`find sum 1 7`#linebreak()`plus 7 -3`#linebreak()`find sum 1 3`#linebreak()`minus 6 0`#linebreak()`plus 1 1`#linebreak()`find max 1 7`], [`5`#linebreak()`1`#linebreak()`31`#linebreak()`9`#linebreak()`6`],
)
