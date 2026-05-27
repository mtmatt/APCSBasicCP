#import "../../template.typ": *

== Lazy Tag
=== Concept
The segment tree we implemented earlier only supports point updates. If we need to perform range additions, it would be very time-consuming.
Therefore, someone came up with a technique: if the range to be modified happens to completely cover some interval in the segment tree,
we can first mark that node with a tag. The tag is only propagated downward when we need to access its child intervals.
Since we mark at most $O \( log n \)$ intervals at a time, range updates can improve from
$O \( n log \( n \) \)$ to $O \( log \( n \) \)$.

=== Implementation
First, we need to add some fields to the node struct. Since the mark is called a Tag, the
`tag` variable in the following code represents our lazy tag.

#code(title: [Lazy Tag node])[
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

Next, we add some functions to the node struct. The following example demonstrates range addition (adding a value to every element in a range).

#code(title: [Lazy Tag node])[
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

Another approach is to use an array-based implementation, where a separate array called `tag` is maintained. The overall structure is largely the same as the pointer-based segment tree above, so it is left as an exercise for the reader.

=== Examples and Exercises
==== Example: TIOJ 1224 Rectangle Area Coverage Calculation
*Problem Statement*

Given many rectangles on a plane, compute the total area they cover.

*Input*

The input contains a single test case.

The first line contains a positive integer $n$, the number of rectangles
($1 lt.eq n lt.eq 100 \, 000$).

The next $n$ lines each contain four integers $L \, R \, D \, U$
($0 lt.eq L < R lt.eq 1 \, 000 \, 000$；$0 lt.eq D < U lt.eq 1 \, 000 \, 000$),
representing the left, right, bottom, and top boundaries of the rectangle.

*Output*

Print the total covered area.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`2`#linebreak()`1 10 1 10`#linebreak()`0 2 0 2`], [`84`],
)

==== Idea

Imagine a horizontal line sweeping from bottom to top (or top to bottom). The top edge of each rectangle means entering, and the bottom edge means leaving. We maintain how much of the current horizontal range is covered by at least one rectangle. Whenever there is a change (a rectangle enters or leaves), we multiply the currently covered length by the height difference since the last change, and add it to the total area.

#figure(image("../Images/LazyTag1.png", width: 80.0%),
  caption: [
    Rectangle coverage illustration
  ]
)

#figure(image("../Images/LazyTag2.png", width: 80.0%),
  caption: [
    First change
  ]
)

#figure(image("../Images/LazyTag3.png", width: 80.0%),
  caption: [
    Second change
  ]
)

==== Implementation

First, we need a segment tree that supports range addition. Then we sort all the events (rectangle edges), and finally compute the partial areas one by one. Since this problem is a bit special, I am including the complete code below.

Note: Since we only need the total covered length, we can simply use the value at the root node.

#code(title: [Rectangle Area Coverage Solution])[
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
==== Problem: Luogu P3870 [TJOI2009] Light Switches
*Problem Statement*

There are $n$ lights in a row, numbered from left to right as
$1$, $2$, ..., $n$. Perform $m$ operations in order.

There are two types of operations:

+ Given an interval
  $\[ a \, b \]$, toggle the state of all lights in this interval (turn on lights that are off, and turn off lights that are on).

+ Given an interval $\[ a \, b \]$, output how many lights in this interval are currently on.

All lights are initially off.

*Input*

The first line contains two integers $n$ and $m$, the number of lights and the number of operations.

The next $m$ lines each contain three integers $c$, $a$, $b$. $c$ indicates the type of operation.

+ When $c = 0$, it is the first type of operation.

+ When $c = 1$, it is the second type of operation.

$a$ and $b$ are the left and right boundaries of the operation interval.

$2 lt.eq n lt.eq 10^5$, $1 lt.eq m lt.eq 10^5$, $1 lt.eq a \, b lt.eq n$, $c in { 0 \, 1 }$

*Output*

For each type-2 operation, output one line containing one integer: the number of lights that are on in the queried interval.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 5`#linebreak()`0 1 2`#linebreak()`0 2 4`#linebreak()`1 2 3`#linebreak()`0 2 4`#linebreak()`1 1 4`], [`1`#linebreak()`2`],
)
==== Problem: Luogu P1438 Boring Sequence
*Problem Statement*

The bored YYB always comes up with things that ordinary people cannot. One day, the bored YYB
came up with a boring problem: The Boring Sequence... (K-peak: Isn't this a dumb problem?)

Maintain a sequence $a_i$ that supports two operations:

`1 l r K D`: Given an arithmetic sequence of length $r - l + 1$ with first term
$K$ and common difference $D$, add it element-wise to $\[ l \, r \]$ of the sequence.
That is:
$a_l = a_l + K \, a_(l + 1) = a_(l + 1) + K + D dots.h a_r = a_r + K + \( r - l \) times D$.

`2 p`: Query the value of the $p$-th element $a_p$ of the sequence.

*Input*

The first line contains two integers $n \, m$: the length of the sequence and the number of operations.

The second line contains $n$ integers, where the $i$-th number is $a_i$.

The next $m$ lines each begin with an integer $o p t$.

If $o p t = 1$, then four integers $l med r med K med D$ follow;

If $o p t = 2$, then one integer $p$ follows.

$0 lt.eq n \, m lt.eq 10^5 \, - 200 lt.eq a_i \, K \, D lt.eq 200 \, 1 lt.eq l lt.eq r lt.eq n \, 1 lt.eq p lt.eq n$

*Output*

For each query, print the answer on one line.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 2`#linebreak()`1 2 3 4 5`#linebreak()`1 2 4 1 2`#linebreak()`2 3`], [`6`],
)
