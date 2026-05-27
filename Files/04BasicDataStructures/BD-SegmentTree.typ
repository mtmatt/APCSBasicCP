#import "../../template.typ": *

== Segment Tree
The competitive programming version.

=== Usage and Concepts

A segment tree can not only be used to quickly answer range sum queries, but also to perform many other range-related operations. The general structure of the intervals is illustrated below.

#align(center)[#image("../Images/SEG.png", width: 100%)]

Each interval stores a different value depending on the situation, such as the maximum/minimum, or the interval sum.

Each interval can then be decomposed into $O(log(n))$ sub-intervals. For example, `2-7` can be split into `2, 3-4, 5-6, 7`.

#align(center)[#image("../Images/SEG2.png", width: 100%)]

A query always starts from the widest interval. In the diagram, if we want to query the range `2-7`, we start from the interval `1-8`. Since `1-8` does not fully contain `2-7`, we recurse downward and split into `1-4` and `5-8` to query again.

Then, since `1-4` and `5-8` are still not fully contained in `2-7`, we recurse again, this time splitting into `1-2`, `3-4`, `5-6`, and `7-8`.

This time, `3-4` and `5-6` are both fully contained, so we can return their values directly. However, `1-2` and `7-8` are still not fully contained, so these two intervals must recurse downward once more.

The most important rule during a query is: if the current interval is fully contained in the query range, return immediately; if the current interval has no overlap with the query range, do not recurse into it; otherwise, split the interval into two halves and recurse.

=== Implementation

We can observe that this forms a binary tree, so there are two approaches: pointer-based and array-based. The following implementations use range sum as an example.

*Array-based*

#tip[
Set the root node's index to 1. In a complete binary tree, the left child will be at `idx * 2` and the right child at `idx * 2 + 1`.
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

*Pointer-based*

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

=== Examples and Practice
==== Problem: ZJe409 Segment Tree

*Problem Statement*

You need to use a segment tree to support two types of operations.

+ Update the value of $A[x]$ to $y$
+ Query the difference between the maximum value `maxA` and the minimum value `minA` in the range $A[X]$-$A[Y]$


==== Problem: Tactical Database (110 Yizhong CS Club Internal Contest, Problem F)

*Problem Statement*

You need to support the following operations on an array.

+ Query range sum
+ Query range maximum and minimum values
+ Point add/subtract a value


*Input Description*

The first line of input contains two numbers $n, q$. The next line contains $n$ numbers. Then there are $q$ operations, each of which may be one of the following five types.

+ Query range sum: `find sum` $(l)$ $(r)$
+ Query range max/min: `find` $max/min (l)$ $(r)$
+ Point add/subtract: `plus/minus` (position) $(k)$


Adjacent numbers are separated by spaces.
$n, q <= 100000 , a[i] <= 100000$


*Output Description*

Answer each query operation.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7 10`#linebreak()`1 2 3 4 5 6 7`#linebreak()`find max 2 5`#linebreak()`find min 1 4`#linebreak()`minus 3 1`#linebreak()`plus 2 4`#linebreak()`find sum 1 7`#linebreak()`plus 7 -3`#linebreak()`find sum 1 3`#linebreak()`minus 6 0`#linebreak()`plus 1 1`#linebreak()`find max 1 7`], [`5`#linebreak()`1`#linebreak()`31`#linebreak()`9`#linebreak()`6`],
)
