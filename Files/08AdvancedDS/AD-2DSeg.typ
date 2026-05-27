#import "../../template.typ": *

== 2D Segment Tree
=== Introduction
Also known as a segment tree of segment trees (tree-within-tree). It is somewhat similar to a 2D prefix sum or BIT, but since it is considerably more difficult, it is placed in the advanced data structures chapter.

=== Concept
We embed $n$ segment trees inside another segment tree. When updating, we first locate the outer tree node we want to modify, then update the inner node we need. For queries, we apply the same concept as in 1D: query $O \( log n \)$ outer nodes, each requiring $O \( log m \)$ inner node accesses.

Therefore, both operations have time complexity $O \( log n times log m \)$. Since $n ≐ m$ in most cases, this can also be written as $O \( log^2 \( n \) \)$.

#figure(image("../Images/2DSeg1.png"),
  caption: [
  ]
)

=== Implementation
We first implement seg1D, then embed it inside seg2D.

#code(title: [2D Segment Tree])[
  ```cpp
int N,M;
void amax(int &a,int b){
    a=max(a,b);
    return;
}

struct seg1D{
    int val=0;
    seg1D *lch=nullptr,*rch=nullptr;

    void pull(){
        val=0;
        if(lch) amax(val,lch->val);
        if(rch) amax(val,rch->val);
    }

    void modify(int x,int p,int lb=0,int rb=N){
        if(lb==rb){
            amax(val,p);
            return;
        }
        int mid=lb+rb>>1;

        if(x<=mid){
            if(!lch)lch=newseg1D;
            lch->modify(x,p,lb,mid);
        }

        if(mid<x){
            if(!rch) rch=new seg1D;
            rch->modify(x,p,mid+1,rb);
        }
        pull();
    }

    int query(int l,int r,int lb=0,int rb=N){
        if(l<=lb && rb<=r) return val;

        int mid=lb+rb>>1;
        int ret=0;
        if(l<=mid && lch) amax(ret,lch->query(l,r,lb,mid));
        if(mid<r && rch) amax(ret,rch->query(l,r,mid+1,rb));
        return ret;
    }
};

struct seg2D{
    seg1D seg;
    seg2D *lch=nullptr,*rch=nullptr;

    void modify(int x,int y,int p,int lb=0,int rb=N){
        seg.modify(y,p);
        if(lb==rb) return;

        int mid=lb+rb>>1;
        if(x<=mid){
            if(!lch) lch=new seg2D;
            lch->modify(x,y,p,lb,mid);
        }

        if(mid<x){
            if(!rch) rch=new seg2D;
            rch->modify(x,y,p,mid+1,rb);
        }
    }

    int query(int xl,int xr,int yl,int yr,int lb=0,int rb=N){
        if(xr<xl || yr<yl) return 0;
        if(xl<=lb && rb<=xr) return seg.query(yl,yr);
        int mid=lb+rb>>1;
        int ret=0;

        if(xl<=mid && lch) amax(ret,lch->query(xl,xr,yl,yr,lb,mid));
        if(mid<xr && rch) amax(ret,rch->query(xl,xr,yl,yr,mid+1,rb));
        return ret;
    }
};
  ```
]

=== It Doesn't Have to Be a Segment Tree Inside
In fact, you can replace the inner 1D segment tree with something else, such as a BIT or a Treap (can't wait!).

=== Examples and Exercises
==== Problem: ZJ c571 3D Partial Order
Given $n$ objects, each with three parameters $x_i \, y_i \, z_i$,
find the maximum number of objects you can select such that, after some ordering, all three parameters are strictly increasing.
==== Problem: CF19D Points
*Problem Statement*

Pete and Bob invented a new game. Bob took a piece of paper and drew a Cartesian coordinate system on it: the point
$\( 0 \, 0 \)$ is at the bottom-left corner, the $x$-axis extends to the right, and the $y$-axis extends upward. Pete gives Bob three types of requests:

- add x y: Mark a point at coordinates $\( x \, y \)$ on the paper. For each such request, it is guaranteed that point $\( x \, y \)$ is not already marked.

- remove x y: Erase the previously marked point at coordinates $\( x \, y \)$ from the paper. For each such request, it is guaranteed that point $\( x \, y \)$ is currently marked.

- find x y: Among all marked points that are strictly to the upper-right of $\( x \, y \)$, Bob selects the leftmost one, and among ties, the lowest one, then returns its coordinates to Pete.

Bob can handle 10, 100, or 1000 requests, but when the number of requests grows to $2 times 10^5$, Bob cannot keep up. He now needs a program that can answer all of Pete's requests. Please help Bob!

*Input*

The first line contains a number $n$ ($1 lt.eq n lt.eq 2 times 10^5$),
the number of requests. The next $n$ lines describe each request. `add x y` marks a point,
`remove x y` erases a point, `find x y` finds the bottom-leftmost marked point strictly to the upper-right.
All coordinates in the input are non-negative and do not exceed $10^9$.

*Output*

For each `find x y` request, output one line with the coordinates of the bottom-leftmost marked point strictly to the upper-right of $\( x \, y \)$.
If no such marked point exists, output -1.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`7`#linebreak()`add 1 1`#linebreak()`add 3 4`#linebreak()`find 0 0`#linebreak()`remove 1 1`#linebreak()`find 0 0`#linebreak()`add 1 1`#linebreak()`find 0 0`], [`1 1`#linebreak()`3 4`#linebreak()`1 1`],
)

=== Other Notes
2D segment trees almost never support lazy tags. If you need that functionality, consider a KD-tree or a quadtree instead. (I will look into it when I have time.)
