#import "../../template.typ": *

== Persistence
=== Concept
The concept of persistence is to preserve all versions, like the `ctrl+z` undo feature we use on computers every day.

Consider the case where we want to query some interval after the $k$-th operation. There are two known approaches.

+ Sort the queries by $k$ and process them in order, then re-sort the output.

+ Use $n$ separate segment trees, but this consumes too much space.

Persistence allows us to back up all versions using the minimum amount of space.
For a segment tree, this is achieved by sharing nodes between versions.

#figure(image("../Images/SEG3.png", width: 80.0%),
  caption: [
  ]
)

=== Implementation
#code(title: [Persistent Segment Tree])[
  ```cpp
struct node{
    node *lch,*rch;
    int val;

    node(){
        lch=rch=nullptr;
        val=0;
    }

    void pull(){
        val=lch->val + rch->val;
    }
};

void build(int l,int r,node *&p){
    p=new node();
    if(l==r) return;
    int mid=(l+r)>>1;
    build(l,mid,p->lch);
    build(mid+1,r,p->rch);
    p->pull();
}

void modify(int pos,int val,int lb,int rb,node *pre,node *&cur){
    // allocate a new node for every changed node
    cur=new node();

    if(lb==rb){
        cur->val=pre->val+val;
        return;
    }

    // share unchanged nodes
    cur->lch=pre->lch;
    cur->rch=pre->rch;
    int mid=(lb+rb)>>1;

    if(pos<=mid) modify(pos,val,lb,mid,pre->lch,cur->lch);
    if(mid<pos) modify(pos,val,mid+1,rb,pre->rch,cur->rch);

    cur->pull();
}

int query(int l,int r,int lb,int rb,node *ver){
    if(l<=lb && rb<=r) return ver->val;

    int ret=0;
    int mid=(lb+rb)>>1;
    if(l<=mid) ret+=query(l,r,lb,mid,ver->lch);
    if(mid<r) ret+=query(l,r,mid+1,rb,ver->rch);
}
  ```
]

=== Examples and Exercises
==== Example: Luogu P3834 [Template] Persistent Segment Tree 2
*Problem Statement*

This is a classic introductory problem for persistent value-indexed segment trees: static range $k$-th smallest.

The data has been strengthened; please use a persistent value-indexed segment tree. Also pay attention to constant-factor optimization.

Given a sequence $a$ of $n$ integers, for each specified closed interval $\[ l \, r \]$,
query the $k$-th smallest value in that range.

*Input*

The first line contains two integers representing the length of the sequence $n$ and the number of queries $m$.

The second line contains $n$ integers, where the $i$-th integer is $a_i$.

The next $m$ lines each contain three integers $l \, r \, k$, asking for the $k$-th smallest value in the interval
$\[ l \, r \]$.

$1 lt.eq n \, m lt.eq 2 times 10^5$, $\| a_i \| lt.eq 10^9$, $1 lt.eq l lt.eq r lt.eq n$, $1 lt.eq k lt.eq r - l + 1$

*Output*

For each query, output one line with one integer as the answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 5`#linebreak()`25957 6405 15770 26287 26465`#linebreak()`2 2 1`#linebreak()`3 4 1`#linebreak()`4 5 1`#linebreak()`1 2 2`#linebreak()`4 4 1`], [`6405`#linebreak()`15770`#linebreak()`26287`#linebreak()`25957`#linebreak()`26287`],
)

==== Persistent Segment Tree Approach

We use a value-indexed segment tree that stores how many times each number has appeared, and apply persistence to record all versions. The $N$-th version from left to right corresponds to the segment tree for the interval $\[ 1 \, N \]$.

With this, we can answer queries. To find the $k$-th smallest number, note that the $k$-th smallest is greater than exactly $k - 1$ numbers that come before it. So we can perform a binary search on the segment tree: if the current node already accounts for more than $k$ numbers smaller than the target, search for a smaller number; otherwise search for a larger one.

Next, since the value range is very large, we can apply discretization instead of dynamic node allocation (because the time limit is very tight).

#code(title: [Range k-th Smallest Solution])[
  ```cpp
struct node{
    node *lch,*rch;
    int val;

    node(){
        lch=rch=nullptr;
        val=0;
    }

    void pull(){
        val=lch->val + rch->val;
    }
};

void build(int l,int r,node *&p){
    p=new node();
    if(l==r) return;
    int mid=(l+r)>>1;
    build(l,mid,p->lch);
    build(mid+1,r,p->rch);
    p->pull();
}

void modify(int pos,int lb,int rb,node *pre,node *&cur){
    // allocate a new node for every changed node
    cur=new node();

    if(lb==rb){
        cur->val=pre->val+1;
        return;
    }

    // share unchanged nodes
    cur->lch=pre->lch;
    cur->rch=pre->rch;
    int mid=(lb+rb)>>1;

    if(pos<=mid) modify(pos,lb,mid,pre->lch,cur->lch);
    if(mid<pos) modify(pos,mid+1,rb,pre->rch,cur->rch);

    cur->pull();
}

int query(int val,int lb,int rb,node *l,node *r){
    if(lb==rb) return lb;
    int k=r->lch->val - l->lch->val;
    int mid=(lb+rb)>>1;
    if(val<=k) return query(val,lb,mid,l->lch,r->lch);
    else return query(val-k,mid+1,rb,l->rch,r->rch);
}

int main(){
    // input
    for(int i=0;i<n;++i){
        modify(v[i],1,mxn,ver[i],ver[i+1]);
    }

    int l,r,k;
    while(m--){
        // input the query range and k
        query(k,1,mxn,ver[l-1],ver[r])-1;
    }
}
  ```
]

Luogu P4587 \[FJOI2016\] Mysterious Number

*Problem Statement*

The mysterious number of a multiset $S$ is defined as the smallest positive integer that cannot be represented as the sum of any subset of $S$.
For example,
$S = 1 \, 1 \, 1 \, 4 \, 13$: $1 = 1$, $2 = 1 + 1$, $3 = 1 + 1 + 1$, $4 = 4$, $5 = 4 + 1$, $6 = 4 + 1 + 1$, $7 = 4 + 1 + 1 + 1$.

$8$ cannot be represented as the sum of any subset of $S$, so the mysterious number of $S$ is $8$.

Given a sequence $a$ of $n$ positive integers and $m$ queries, each query contains two parameters
$l \, r$. You need to find the mysterious number of the multiset formed by $a_l \, a_(l + 1) \, dots.h.c \, a_r$.

*Input*

The first line contains an integer $n$, the number of integers. The second line contains $n$ positive integers, numbered from $1$.

The third line contains an integer $m$, the number of queries. The next $m$ lines each contain two integers $l \, r$.

$1 lt.eq n \, m lt.eq 10^5$, $sum a lt.eq 10^9$

*Output*

For each query, output one line with the corresponding answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 2 4 9 10`#linebreak()`3`#linebreak()`1 1`#linebreak()`1 2`#linebreak()`1 3`], [`2`#linebreak()`4`#linebreak()`8`],
)
