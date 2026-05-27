#import "../../template.typ": *

== Treap
This is probably the first unit whose title is in English. It does have a Chinese name though: tree-heap (樹堆).

=== Introduction
A Treap is a randomly balanced binary search tree. The Treap described here is implemented using merge/split,
which has many advantages. We will first explain the basic rules
and what the merge/split functions do, then explain how to implement them.

The name "Treap" comes from combining Tree and Heap.
Each node stores at least two values: `val` and `pri`. `val` (also called `key`) is the content, while
`pri` is used for balancing.

=== Rules and Preliminaries
Every node's `pri` value must be smaller (or larger) than those of its left and right subtrees. The `val` values on the tree satisfy
the Binary Search Tree (BST) property. In case someone has forgotten or does not know what the BST property is,
here is an explanation using a problem I once wrote.
==== Example: 1st Excellence Cup C. Safe Sorter
#figure(image("../Images/SaveSorter.png"),
  caption: [
  ]
)

- If the node has no safe yet, the incoming safe occupies that node.

- Otherwise, if the incoming safe contains more gold bars than the safe at the current node, it is sent to the right.

- Otherwise, it is sent to the left.

- It must keep being sent until it occupies a node of its own.

As shown in the figure:

- The first safe placed has 8 gold bars.

- The second has 10, so it is placed to the right.

- The third has 14,
  so it first goes right, then finds that node is occupied too, and goes right again.

- The fourth has 3, so it is placed to the left.

- And so on.

The so-called random balancing means that the balance is achieved by assigning each node a random `pri` value.
The two most important operations in a Treap are the following, one of which involves `pri`.

- merge(a, b): Merge two trees a and b. Precondition: every value in a is less than every value in b.

- split(a, b, p): Split one tree into a and b, where a contains all values $lt.eq p$ and b contains all values $> p$.

Both operations are defined recursively. First, merge.

==== merge

- If at least one of a, b is a null pointer, return the non-null one (if both are null, return null).

- Otherwise, to maintain both the BST and heap properties simultaneously, we check which one has the smaller `pri` value. In my implementation, the node with the smaller `pri` is placed higher (closer to the root).

- If a has the smaller `pri`, we return a as the root of the merged tree. But before that, we must determine a's right subtree (since b has not been fully merged yet), so we recurse downward.

- The case for b is the opposite, since all values in b are greater than those in a.

==== split

split is more complex, because it must simultaneously satisfy both Treap properties.

- If T (the Treap to be split) is a null pointer, the whole tree has been split, so set both a and b to null.

- Otherwise, split into two cases: T's root value is $lt.eq p$, or $> p$.

- If T's root value is $lt.eq p$, assign T's root and its left subtree to a,
  then continue splitting T's right subtree into a's right subtree and b.

- Otherwise, assign T's root and its right subtree to b, then continue splitting T's left subtree into b's left subtree and a.

==== Order-Statistics Tree

First, let me introduce the order-statistics tree. It stores an extra value in each node: the subtree size (`size`). This enables additional features, such as: finding the rank of a value k in the tree, deleting the smallest element greater than k, and finding the k-th smallest element.

To support this in a Treap, we need to implement two additional functions: `pull` and `SplitBySize` (`splitSz`).

First, I will write out the complete node struct and a helper function for getting the size of the subtree under a given pointer, to facilitate the explanation below. As a side note, to maintain the correctness of the order-statistics tree, `pull` must be called every time the tree is modified.

#code(title: [node of Treap])[
  ```cpp
struct node{
    // key is the sorting criterion
    // pri is the heap criterion
    int key,pri,sz;
    node *lch,*rch;

    node(int _key){
        key=_key;
        sz=1;
        lch=rch=nullptr;
        // RandomInt() will be implemented later
        pri=RandomInt();
    }

    void pull(){
        // count self as well
        sz=1;
        // the condition is equivalent to lch!=nullptr
        // add the sizes of left and right subtrees for the complete count
        if(lch) sz+=lch->sz;
        if(rch) sz+=rch->sz;
    }
};

int fs(node *a){
    // if a is a null pointer, sz (return value) is 0
    return a ? a->sz : 0;
}
  ```
]

==== SplitBySize

This function is similar to split, but the splitting criterion is different. SplitBySize
splits the tree into a and b, where a contains the smallest s elements and b contains the rest. The detailed steps are as follows.

- Same as split: if T is null, the split is complete; set both a and b to null.

- Otherwise, if the number of elements in T's left subtree is less than s, assign T and its left subtree to a,
  then continue splitting $s - \( T 's \, left \, subtree \, size \) - 1 \( T \, itself \)$ elements from T's right subtree into a's right subtree.

- Otherwise, assign T and its right subtree to b, then split s elements from T's left subtree into a.

==== Random Numbers

C++ has built-in random number functions. They are provided below for reference.

#code(title: [C++ Random Numbers])[
  ```cpp
// Simple approach, but may be hackable
#include<crand>

int RandomInt(){
    return rand();
}

// Longer, but harder to exploit
#include<random>

unsigned seed=chrono::steady_clock().now().time_since_epoch().count();
mt19937 rng(seed);

int RandomInt(){
    return rng();
}
  ```
]

Finally, here is the complete code.

#code(title: [Treap Core])[
  ```cpp
node *merge(node *a,node *b){
    if(!a || !b) return a ? a : b;

    if(a->pri < b->pri){
        a->rch=merge(a->rch,b);
        a->pull();
        return a;
    }else{
        b->lch=merge(a,b->lch);
        b->pull();
        return b;
    }
}

void split(node *T,node *&a,node *&b,int p){
    if(!T){
        a=b=nullptr;
        return;
    }

    if(T->key <= p){
        a=T;
        split(T->rch,a->rch,b,p);
        a->pull();
    }else{
        b=T;
        split(T->lch,a,b->lch,p);
        a->pull();
    }
}

void splitSz(node *T,node *&a,node *&b,int s){
    if(!T){
        a=b=nullptr;
        return;
    }

    if(fs(T->lch)<s){
        a=T;
        splitSz(T->rch,a->rch,b,s-fs(T->lch)-1);
        a->pull();
    }else{
        b=T;
        splitSz(T->lch,a,b->lch,s);
        b->pull();
    }
}
  ```
]

=== Basic Operations
With these functions, most subsequent operations become simple,
including insert, erase, find, and more, because they can all be composed using merge
and split. Many operations even have more than one valid implementation. Let us go through them.

==== Insert

Insert can be broken down into a few simple steps. Suppose the value to insert is v.

- Split the entire tree (stored in the `rt` pointer) into two trees: one with values $lt.eq v$ (call it `rt`) and one with values $> v$ (call it `b`).

- Allocate a new node `a(v)` using the value v
  (if you are unfamiliar with dynamic memory allocation, review it first).

- Merge `rt` and `a`, and assign the merged tree back to `rt`.

- Merge `rt` and `b`, and assign the merged tree back to `rt`.

==== Erase

Erase can similarly be broken into a few steps. Suppose the value to erase is v.

\1. Erase all elements equal to v (works for integers only):

- Split the entire tree (`rt`) into two trees: values $lt.eq v$ (`rt`) and values $> v$ (`b`).

- Split `rt` again into values $lt.eq v - 1$ (`rt`) and values $> v - 1$ (`a`).

- Delete the entire subtree `a`.

- Merge `rt` and `b`, assign back to `rt`.

\2. Erase one element equal to v (works for integers only):

- Split the entire tree (`rt`) into values $lt.eq v - 1$ (`rt`) and values $> v - 1$ (`b`).

- Split `b` into the leftmost one element (`b`) and the rest (`a`).

- Delete `b`.

- Merge `rt` and `b`, assign back to `rt`.

If dealing with floating-point numbers, a different approach may be needed, but this is rarely required.

==== Count

Suppose we want to count how many times value v appears.

- Split the entire tree (`rt`) into values $lt.eq v$ (`rt`) and values $> v$ (`b`).

- Split `rt` into values $lt.eq v - 1$ (`rt`) and values $> v - 1$ (`a`).

- Store the size of `a` in a variable.

- Merge `rt` and `a`, assign back to `rt`.

- Merge `rt` and `b`, assign back to `rt`.

==== Kth Small Element

Suppose we want to find the p-th smallest element.

- Split the entire tree (`rt`) into the p leftmost elements (`rt`) and the rest (`b`).

- Split `rt` into the p-1 leftmost elements (`rt`) and the rest (`a`).

- Store the value of `a` in a variable.

- Merge `rt` and `a`, assign back to `rt`.

- Merge `rt` and `b`, assign back to `rt`.

Here is the complete code.

#code(title: [Treap Basic Operations])[
  ```cpp
void insert(int v){
    node *a=new node(v),*b;
    split(rt,rt,b,v);
    rt=merge(rt,a);
    rt=merge(rt,b);
}

// This function deletes the left subtree, then the right subtree, then itself, recursively deleting the entire tree.
void delete_tree(node *n){
    if(n->lch) delete_tree(n->lch);
    if(n->rch) delete_tree(n->rch);
    delete(n);
}

// erase all element between (v-1~v] -> corresponds to case 1
void erase(int v){
    node *a,*b;
    split(rt,rt,b,v);
    split(rt,rt,a,v-1);// or v-eps
    // it's better to use delete_tree function
    delete(a);
    rt=merge(rt,b);
}

// erase one element between (v-1~v] -> corresponds to case 2
void erase(int v){
    node *a,*b;
    split(rt,rt,b,v-1);
    splitSz(b,b,a,1);
    delete(b);
    rt=merge(rt,b);
}

int count(int v){
    node *a,*b;
    split(rt,rt,b,v);
    split(rt,rt,a,v-1);// or v-eps
    int ret=fs(a);
    rt=merge(rt,a);
    rt=merge(rt,b);
    return ret;
}

int kth(int v){
    node *a,*b;
    splitSz(rt,rt,b,p);
    splitSz(rt,rt,a,p-1);
    int ret=a->key;
    rt=merge(rt,a);
    rt=merge(rt,b);
    return ret;
}
  ```
]

So you thought it was just a balanced BST? No, no, no — it is much more powerful than that.

=== Advanced Operations
If we treat the in-order traversal of the tree as the order of a sequence (as shown below), we can implement many more powerful features.
In fact, everything a segment tree can do, a Treap can do too. But a Treap
can even do things that a segment tree cannot.

#figure(image("../Images/Treap1.png", width: 60.0%),
  caption: [
    Treap representing a sequence
  ]
)

In this mode, we can remove the `key` field and use only `splitSz` and `merge`.

==== Insert

Suppose we want to insert value v at position p.

- Split the entire tree (`rt`) into the first p-1 elements (`rt`) and the rest (`b`).

- Allocate a new node `a(v)` with value v.

- Merge `rt` and `a`, assign back to `rt`.

- Merge `rt` and `b`, assign back to `rt`.

==== Erase

Suppose we want to delete the p-th element.

- Split the entire tree (`rt`) into the first p-1 elements (`rt`) and the rest (`b`).

- Split `b` into the first one element (`b`) and the rest (`a`).

- Delete `a`.

- Merge `rt` and `b`, assign back to `rt`.

==== Range Operations

Before introducing range operations, we need to add more fields and functions to the node struct, so the node will contain more code. (The following code adds many features; in practice you may not need all of them.)

#code(title: [Treap node for representing a sequence])[
  ```cpp
const int INF=0x3f3f3f3f

struct Treap{
    struct node{
        // value of this node
        int val;
        // maintains Treap property
        int pri,sz;
        // used for range queries
        int sum,mx,mn;
        // supports range reversal
        bool rev_tag;
        // supports range addition
        int add_tag;
        // left and right children
        node *lch,*rch;

        node(int _val){
            val=sum=mx=mn=_val;
            lch=rch=nullptr;
            sz=1;
            pri=rng();
        }

        void pull(){
            sz=1;
            sum=mx=mn=val;

            if(lch){
                sz+=lch->sz;
                sum+=lch->sum;
                mx=max(mx,lch->mx);
                mn=min(mn,lch->mn);
            }

            if(rch){
                sz+=rch->sz;
                sum+=rch->sum;
                mx=max(mx,rch->mx);
                mn=min(mn,rch->mn);
            }
        }

        // reverse the interval below this node
        void rev(){
            rev_tag=!rev_tag;
        }

        // call before modifying a node
        void push(){
            if(rev_tag){
                swap(lch,rch);
                if(lch)
                    lch->tag=true;
                if(rch)
                    rch->tag=true;
            }

            if(lch)
                lch->add_tag+=add_tag;
            if(rch)
                rch->add_tag+=add_tag;
            add_tag=0;
        }
    };
};
  ```
]

At the same time, we need to add `push` calls to the original merge/split code. The exact locations are shown below.

#code(title: [Where to place push])[
  ```cpp
struct Treap{
    node *merge(node *a,node *b){
        if(!a || !b) return a ? a : b;

        if(a->pri < b->pri){
            a->push();
            a->rch=merge(a->rch,b);
            return a;
        }else{
            b->push();
            b->lch=merge(a,b->lch);
            return b;
        }
    }

    void splitSz(node *T,node *&a,node *&b,int s){
        if(!T){
            a=b=nullptr;
            return;
        }

        T->push();

        if(fs(T->lch)<s){
            a=T;
            splitSz(T->rch,a->rch,b,s-fs(T->lch)-1);
            a->pull();
        }else{
            b=T;
            splitSz(T->lch,a,b->lch,s);
            b->pull();
        }
    }
};
  ```
]

For the operations below, the pattern is: cut out the target interval, perform the desired operation, then merge it back.

==== Range Query (Min, Max, Sum)

Suppose we want to query the interval $\[ l \, r \]$.

- Split `rt` into the first r elements (`rt`) and the rest (`b`).

- Then split `rt` into the first l-1 elements (`rt`) and the rest (`a`).

- At this point, `a` contains the interval $\[ l \, r \]$, and its `sum`, `mx`, `mn`
  fields hold the sum, maximum, and minimum of the interval.

- Finally, merge everything back in order and return the answer.

==== Point Update

Cut out the position to be updated, perform the update, then merge back. Remember to call `push` after the update.

==== Range Operation

Suppose we want to perform an operation on $\[ l \, r \]$.

- Split `rt` into the first r elements (`rt`) and the rest (`b`).

- Then split `rt` into the first l-1 elements (`rt`) and the rest (`a`).

- At this point, `a` contains the interval $\[ l \, r \]$; apply the operation directly to it.

- Finally, merge everything back in order.

Of course, just like with segment trees, range operations typically require a lazy tag.

Here is the complete code.

#code(title: [Treap Advanced Operations])[
  ```cpp
int query(int l,int r){
    node *a,*b;
    splitSz(rt,rt,b,r);
    splitSz(rt,rt,a,l-1);
    // choose sum, mx, or mn based on your needs
    int ret=a->sum;
    rt=merge(rt,a);
    rt=merge(rt,b);
    return ret;
}

// Point query: reuse the range query function with a length-1 interval
// but it will be slightly slower
int get(int p){
    return query(p,p);
}

void modify(int p,int v){
    node *a,*b;
    splitSz(rt,rt,a,p-1);
    splitSz(a,a,b,1);
    a->val=v;
    rt=merge(rt,a);
    rt=merge(rt,b);
}

// range reversal
void reverse(int l,int r){
    node *a,*b;
    splitSz(rt,rt,b,r);
    splitSz(rt,rt,a,l-1);
    if(a) a->rev();
    rt=merge(rt,a);
    rt=merge(rt,b);
}

// range addition
void add(int l,int r,int v){
    node *a,*b;
    splitSz(rt,rt,b,r);
    splitSz(rt,rt,a,l-1);
    a->val+=v;
    a->push();
    rt=merge(rt,a);
    rt=merge(rt,b);
}
  ```
]

=== Destructor
For multiple test cases, you may need to free memory. Due to the binary tree nature of a Treap,
the entire tree can be deleted recursively.

#code(title: [Treap Destructor])[
  ```cpp
void DeleteTree(node *n){
    if(n->lch) DeleteTree(n->lch);
    if(n->rch) DeleteTree(n->rch);
    delete(n);
}

~Treap(){
    if(rt) DeleteTree(rt);
}
  ```
]

=== Some Fun Extras
These are written just for fun and are almost never used in practice, so no explanation is given.

#code(title: [Other Features])[
  ```cpp
int size(){
    return fs(rt);
}

bool empty(){
    return size()==0;
}

void push_back(num v){
    insert(size()+1,v);
}

void push_front(num v){
    insert(1,v);
}

void pop_back(){
    erase(size()+1);
}

void pop_front(){
    erase(1);
}

void resize(int sz){
    while(size()<sz){
        push_back(0);
    }
    while(size()>sz){
        pop_back();
    }
}

void resize(int sz,num v){
    while(size()<sz){
        push_back(v);
    }
    while(size()>sz){
        pop_back();
    }
}

Treap(){}
Treap(int sz){
    resize(sz);
}

Treap(int sz,int v){
    resize(sz,v);
}
  ```
]

=== Persistence
Still under research$dots.h.c$

=== Summary
The Treap has many more operations available; I have not, and could not, list them all. Just remember
that merge and split can create endless possibilities.

However, be careful: Treap uses a large amount of memory and time. Even though the complexity is the same $O \( log \( n \) \)$,
at the same scale a Treap will be slower. Of course, for some problems that would otherwise require a value-indexed segment tree, a Treap may run faster,
since the complexities differ: $O \( log C \) > O \( log n \) \, C lt.eq 10^12 \, n lt.eq 10^5$.

=== Examples and Exercises
==== Problem: 1st Excellence Cup F. Safe Sequence (Hard)
*Problem Statement*

You are the head of the safe management department at a bank. Since business has been slow lately, the bank manager decided to play a game with the employees. The following operations are used in the game.

+ Add a safe to the position after the $x$-th safe in the sequence, and this safe currently contains $y$ gold bars.

+ Reverse the safes in $\[ l \, r \]$ ~Note 1~

+ Query the total number of gold bars in the interval $\[ l \, r \]$.

+ Remove $y$ gold bars from the $x$-th safe in the current sequence.

+ Add $y$ gold bars to the $x$-th safe in the current sequence.

*Input*

The first line contains $1$ number $t$, indicating $t$ test cases.

For each test case, the first line contains $2$ numbers $n \, q$, representing the initial number of safes.

The second line contains $n$ numbers $a_1 \, a_2 . . . a_n$, where $a_i$ is the number of gold bars in the $i$-th safe.

The next $q$ lines each correspond to one operation (described below).

Corresponding to the $k$-th operation in the problem statement:

+ Input $1$ $x$ $y$

+ Input $2$ $l$ $r$

+ Input $3$ $l$ $r$

+ Input $4$ $x$ $y$

+ Input $5$ $x$ $y$

$t lt.eq 100$, $n \, q \, a_i \, x \, y lt.eq 10^4$

*Output*

Only operation $3$ requires output: the total number of gold bars in $\[ l \, r \]$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`1`#linebreak()`4 2`#linebreak()`1 2 3 4`#linebreak()`2 1 4`#linebreak()`3 1 3`], [`10`],
)

Note 1: The bank is equipped with a "Quantum Orbital Displacement System",
so there is no need to worry about employees suffering from rhabdomyolysis due to moving too many safes,
or safes being too heavy to move.
==== Problem: CF 702F T-Shirts
*Problem Statement*

A large batch of T-shirts goes on sale at a store before spring. There are $n$ types of T-shirts in total. The $i$-th type
has two integer parameters --- $c_i$ and $q_i$, where $c_i$ is the price of the $i$-th T-shirt
and $q_i$ is its quality. Assume the store has an unlimited supply of each type,
but price and quality are generally unrelated.

According to forecasts, $k$ customers will visit the store in the coming month. The $j$-th
customer plans to spend at most $b_j$ on T-shirts.

All customers use the same strategy. First, a customer buys as many of the highest-quality T-shirts as possible,
then buys as many of the next highest-quality T-shirts as possible from the remaining choices,
and so on. Among T-shirts of the same quality, the customer prefers the cheaper one. Customers dislike having duplicate T-shirts,
so no customer buys more than one of the same type.

Determine how many T-shirts each customer will buy according to this strategy. All customers are independent; one customer's purchases do not affect another's.

*Input*

The first line contains a positive integer $n$ ($1 lt.eq n lt.eq 2 times 10^5$) --- the number of T-shirt types.

The next $n$ lines each contain two integers $c_i$ and $q_i$
($1 lt.eq c_i \, q_i lt.eq 10^9$) --- the price and quality of the $i$-th T-shirt.

The next line contains a positive integer $k$ ($1 lt.eq k lt.eq 2 times 10^5$) ---
the number of customers.

The next line contains $k$ positive integers $b_1 \, b_2 \, dots.h.c \, b_k$
($1 lt.eq b_j lt.eq 10^9$), where the $j$-th number is the total budget of the $j$-th customer.

*Output*

The first line of output should contain a sequence of $k$ integers, where the $i$-th number equals the number of T-shirts the $i$-th customer will buy.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`7 5`#linebreak()`3 5`#linebreak()`4 3`#linebreak()`2`#linebreak()`13 14`], [`2 3`],
)
==== Problem: TIOJ 1382 Josephus Problem
*Problem Statement*

Remember the Josephus problem!?
Yes, that Josephus. This time it is the Josephus problem, not the Josephus problem!! (Well, it is a slightly different variant.)

The classic problem goes like this: $n$ people sit in a circle; starting from the beginning, every $k$-th person is eliminated. The question asks what Joseph has for dinner tonight.

Pretty hard, right? Today's problem is much simpler, and rated for general audiences — no one gets killed.

$n$ people sit in a circle in numbered order. Each person's chair is equipped with a "forced ejection device".
A mysterious slip of paper has $n$ numbers written on it, representing how many people to count before each ejection (counting starts from the first person at the beginning).

*Input*

Multiple test cases; use EOF as the terminator (no more than 10 test cases).

The first line of each test case is a number $n$, the number of people.

The second line contains $n$ numbers $a_1 \, a_2 \, dots.h.c \, a_n$, where $a_i$
is the $a_i$-th person to be ejected in the $i$-th round.

$1 lt.eq n \, a_i lt.eq 10^5$

*Output*

Output the ejection order; the numbers are from $1$ to $n$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`2 3 2 3 1`], [`2 5 3 4 1`],
)
