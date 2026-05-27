#import "../../template.typ": *

== Binary Indexed Tree
A Binary Indexed Tree (BIT) is a helper structure for fast dynamic range sum queries.

=== Review
Remember prefix sums? They are also used to compute range sums, but as you may have noticed, if any single value needs to be modified, the entire prefix array must be updated, which increases the time complexity significantly.

The following comparison table illustrates the power of BIT.

#table(columns: 3, stroke: .5pt, inset: 5pt,
  [Data Structure],
  [Range Sum Query],
  [Point Update],
  [Plain Array],
  [$O(n)$],
  [$O(1)$],
  [Prefix Sum],
  [$O(1)$],
  [$O(n)$],
  [BIT],
  [$O(log(n))$],
  [$O(log(n))$],
)

=== Purpose and Concept
BIT is used to compute range sums quickly while also guaranteeing fast updates. It feels like a product combining the advantages of plain arrays and prefix sums, though it is also the most complex of the three. In the diagram below, each number represents the interval that node stores.

#align(center)[#image("../Images/BIT.png", width: 100%)]
#align(center)[_BIT Diagram_]

For example, to find the sum of `1-5`, you can query `1-4` plus `5`. The table below shows the intervals needed for each prefix query.

#table(columns: 8, stroke: .5pt, inset: 5pt,
  [1],
  [1--2],
  [1--3],
  [1--4],
  [1--5],
  [1--6],
  [1--7],
  [1--8],
  [1],
  [1--2],
  [1--2 & 3],
  [1--4],
  [1--4 & 5],
  [1--4 & 5--6],
  [1--4 & 5--6 & 7],
  [1--8],
)

We can observe that when there are $8$ elements, at most $3$ intervals need to be queried to get the prefix sum `1-n`. Then, just like with prefix sums, we can compute any range sum using `(1 to R) - (1 to L-1)`.

=== Implementation
BIT is generally implemented using an array, with each interval's maximum index as the storage position (e.g., `1-4` is stored at position `4`). What about querying and updating? This part is a bit more complex and requires understanding binary representation. If you already understand binary, keep reading.

*lowbit*

lowbit is the rightmost set bit in binary representation. For example: 6 (000110) has lowbit 2 (000010).

*Query*

We can observe that subtracting `lowbit(x)` from $x$ repeatedly will eventually reach 0, and along the way it passes through all the intervals needed. Take 7 as an example.

```text
7(000111) \to 6(000110) \to 4(000100 \to 0(000000))
```

By summing up all the intervals encountered, we get the range sum. This also explains why the query complexity is $O(log(n))$: a number $n$ has at most $log(n)$ bits.

*Update*

Update works similarly, but instead we add `lowbit(x)` to $x$, which ensures all intervals that contain the updated position are also updated. Take $3$ as an example.

```text
3(000011) \to 4(000100) \to 8(001000)
```

Because each step causes a carry, this process also takes at most $O(log(n))$ steps. This also highlights the importance of `lowbit`.

*Code*

#code(title: [BIT])[
```cpp
#define lowbit(x) (x&-x)
// equivalent to: int lowbit(int x){ return x&-x;}
// Using a define or function won't make your code faster to write,
// but it makes it easier to understand.

using ll=long long;

ll bt[200010];
ll a[200010];

// The build function constructs the BIT by updating all elements one by one
void build(int n){
    for(int i=1;i<=n;++i)
        for(int x=i;x<200005;x+=lowbit(x))
            bt[x]+=a[i];
}

// Point add
void add(int x,int k){
    a[x]+=k;
    for(int i=x;i<=200005;i+=lowbit(i))
        bt[i]+=k;
}

// Point set, derived from point add
void modify(int x,int k){
    add(x,k-a[i]);
}

// Query the prefix sum from 1 to x
ll find_sum(int x){
    ll ret=0;
    for(int i=x;i>0;i-=lowbit(i))
        ret+=bt[i];
    return ret;
}

// Compute any range sum using (1 to r) - (1 to l-1)
ll query(int l,int r){
    return find_sum(r)-find_sum(l-1);
}
```
]

=== Examples and Practice
==== Problem: ZJ d796 Regional Survey (adapted from POJ 1195 Mobile phones)

*Problem Statement*

Given a matrix $T(1,1), T(1,2),.... T(N,M)$, either query the sum from $T(x_1,y_1)$ to $T(x_2,y_2)$, or update the value of $T(x_1,y_1)$.

*Input Description*

The first line of each test case contains two positive integers $N$ and $Q$ $( 1 <= N <= 250,  Q <= 5 times 10^5)$.

The next $N$ lines each contain $N$ elements $M$ $( 0 <= M <= 32767 )$.

The next $Q$ lines follow. If the first number is $1$, there are four more numbers:

$x_1 , y_1 , x_2 , y_2,\quad 1 <= x_1 , y_1 , x_2 , y_2 <= 250$

Output the sum of all elements $S={( x , y )   |   x_1 <= x <= x_2, y_1 <= y <= y_2 }$.

If the first number is $2$, there are three more numbers:

$x_1 , y_1 , V,\quad 1 <= x_1 , y_1 <= 250 , 0 <= V <= 32767$

Update $( x_1 , y_1 )= V$. No output is required for this operation.

*Output Description*

For a query operation, output the sum of the elements in the region. For an update operation, output nothing.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 10`#linebreak()`3 2 2 3 7`#linebreak()`4 4 0 3 8`#linebreak()`2 4 7 2 3`#linebreak()`5 9 6 1 4`#linebreak()`7 1 7 1 1`#linebreak()`2 2 2 1`#linebreak()`1 5 4 5 5`#linebreak()`2 2 1 7`#linebreak()`1 3 2 1 5`#linebreak()`1 2 5 4 5`#linebreak()`1 1 2 2 1`#linebreak()`2 2 2 7`#linebreak()`2 4 5 5`#linebreak()`1 3 3 4 5`#linebreak()`1 4 3 2 2`], [`2`#linebreak()`42`#linebreak()`15`#linebreak()`13`#linebreak()`24`#linebreak()`33`],
)

#tip[
BIT can also be extended to two dimensions.
]

==== Problem: ZJ d847 98th Academic Year Central Taiwan District Informatics Olympiad — 2D Rank Finding Problem

*Problem Statement*

2D rank finding problem: Given two points $A = (a_1,a_2)$ and $B = (b_1,b_2)$ in 2D space, we define $A > B$ if and only if $a_1 > b_1$ and $a_2 > b_2$, meaning point A is to the upper-right of point B. Note that not every pair of points has a defined ordering — for example, points A and E, or D and E in the diagram below, are incomparable. Given $N$ points $(x_1,y_1), (x_2,y_2), dots.c, (x_n,y_n)$, define the rank of a point as the number of points in the given set that are smaller than it.

Design a program that reads point names and coordinates from a file and computes the rank of every point in the given set.

*Input Description*

There are multiple test cases.

The first line of each test case contains a number $N   ( 1 <= N <= 10000 )$.

The next $N$ lines each contain two numbers $x,   y   ( 1 <= x , y <= 1000 )$.

*Output Description*

For each point $( x , y )$ in the input order, output how many points $( a , b )$ satisfy $a < x$ and $b < y$ (i.e., are strictly to the lower-left).

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`961 404`#linebreak()`640 145`#linebreak()`983 888`#linebreak()`539 71`#linebreak()`437 532`], [`2`#linebreak()`1`#linebreak()`4`#linebreak()`0`#linebreak()`0`],
)

==== Problem: Low-lying Distance (APCS October 2020)

*Problem Statement*

Given an array of length $2n$ where each number from $1$ to $n$ appears exactly $2$ times.

The low-lying value of $i$ is defined as the number of values smaller than $i$ located between the two occurrences of $i$.

For example, in $[3, 1, 2, 1, 3, 2]$: the low-lying value of $1$ is $0$, of $2$ is $1$, and of $3$ is $3$.

For each number from $1$ to $n$, compute its low-lying value (i.e., how many numbers between its two occurrences are smaller than it), and output the total sum of all low-lying values. The answer may exceed the C++ `int` limit.

*Input Description*

The first line contains a positive integer $n,   n <= 10^5$.

The second line contains $2n$ positive integers separated by spaces, with each number from $1$ to $n$ appearing exactly twice.


*Output Description*

Output the sum of the low-lying values for all numbers from $1$ to $n$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`3 1 2 1 3 2`], [`4`],
)
