#import "../../template.typ": *

== Sorting and Searching

=== Sorting
#align(right)[_Author: ShangJhe Li_]
Sorting means reorganizing all data so that it is convenient for later searching. Many algorithms are built on top of sorting—binary search is one example.

There are many sorting algorithms; the most common are merge sort and quicksort. For detailed sorting algorithms, please refer to other resources.

In competitive programming with C++, we can directly use the `sort()` function to sort everything. (That said, it is still recommended to learn the two algorithms mentioned above.)

In general, `sort` uses `less<T>` for comparison, i.e., ascending order. So we only need to pass the start and end pointers.

#code(title: [Basic sort])[
```cpp
int n,a[100];
sort(a,a+n);
vector<int> b;
sort(b.begin(),b.end());

```
]

If you want to sort in descending order, there are several ways to do so.

#code(title: [Sort in Descending Order])[
```cpp
int n,a[100];
sort(a,a+n,greater<int>());

// Using a comparison function
bool cmp(int a,int b){
    return a>b;
}
vector<int> b;
sort(b.begin(),b.end(),cmp);

// Using a lambda function (faster)
sort(b.begin(),b.end(),[](int a,int b){
    return a>b;
});

// Using a function object (faster)
struct cmp{
    bool operator()(int a,int b){
        return a>b;
    }
}
sort(b.begin(),b.end(),cmp);

```
]

Sharp-eyed readers may have noticed that the last three methods can be used to implement all kinds of custom sorting.

That is exactly why we do not need to implement sorting algorithms from scratch for now.

==== Example: 1st Excellence Cup C. Safe Sorter

Our safe is now placed into a sorter with many nodes (as shown below). The placement rules are as follows.

#align(center)[#image("../Images/SaveSorter.png", width: 100%)]

- If the node is empty, the safe occupies that node.
- Otherwise, if the safe being inserted has more gold bars than the safe already at the node, it is sent to the right.
- Otherwise it is sent to the left.
- This continues until the safe occupies an empty node.


Using the figure below as an example:

- The first safe inserted has 8 gold bars.
- The second has 10, so it is placed to the right.
- The third has 14: it first goes right, finds the right node already occupied, and is sent right again.
- The fourth has 3, so it is placed to the left.
- And so on.


Because the internal structure of the sorter is too large to enter, the developer has built in an elevator traversal order and recording rules for users to reference, to avoid counting safes more than once or missing any. The rules are as follows:

- If this node has a safe to the left, the elevator goes left first.
- When all safes to the left of this node have been recorded, or there is no safe to the left, record the number of gold bars in the safe at the current node.
- Then the elevator goes right.


Using the same figure as an example:

- Node 8 has safes to the left >> elevator goes left
- Enters node 3 >> same >> elevator goes left
- Enters node 1 >> no safes on either side >> record 1 >> elevator returns to node 3
- Left side fully recorded >> record 3 >> safe to the right >> elevator goes right
- Enters node 6 >> safe to the left >> elevator goes left
- Enters node 4 >> no safes on either side >> record 4 >> elevator returns to node 6
- Left side fully recorded >> record 6 >> safe to the right >> elevator goes right
- Enters node 7 >> no safes on either side >> record 7 >> elevator returns to node 6
- Elevator returns to node 3 >> elevator returns to node 8 >> left side fully recorded >> record 8 >> safe to the right >> elevator goes right
- Enters node 10 >> no safe to the left >> record 10 >> safe to the right >> elevator goes right
- Enters node 14 >> safe to the left >> elevator goes left
- Enters node 13 >> no safes on either side >> record 13 >> elevator returns to node 14
- Left side fully recorded >> record 14
- Elevator returns to node 10 >> elevator returns to node 8
- Recording complete


Final result:

`1 3 4 6 7 8 10 13 14`

*Input Format*

- The first line contains $1$ number $t$, the number of test cases.
- The first line of each test case contains $1$ number $n$, the number of safes initially placed.
- The second line contains $n$ numbers $a_1,a_2...a_n$, where $a_i$ is the number of gold bars in the $i$-th safe placed into the sorter.


$t <= 10$ $,$ $n$ $,$ $a_i$ $<= 10^5$

*Output Format*

Record only once after all safes have been placed.

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`2`#linebreak()`3`#linebreak()`3 2 1` `9` `8 10 14 3 1 6 7 4 13`], [`1 2 3`#linebreak()`1 3 4 6 7 8 10 13 14`],
  [Sample Input 2], [Sample Output 2],
  [`18`], [`9`],
)

*Subtasks and Scoring*

- Subtask 1: safes are inserted in decreasing order, worth $10%$
- Subtask 2: no additional constraints, worth $90%$


After reading the problem carefully, we can see that after the complex sequence of operations, the output is exactly the sequence sorted in ascending order. So we can solve it with `sort()`.

=== Linear Search

Honestly, linear search is just brute force. Here is the code directly.

#code(title: [Linear Search])[
```cpp
int finding(vector<int> &v,int target){
    for(int i=0;i<v.size();++i){
        if(v[i]==target){
            return i;
        }
    }
    return -1;
}
```
]

Of course, we can place other interesting conditions inside the if statement. That is also why I still included this section.

=== Binary Search
*Author: Li Zhuoyue*
#align(right)[_Author: Li Zhuoyue_]

Binary search can be applied in many scenarios—whenever you have a *monotone interval*, binary search can be used. The main problem types are:

- Finding a specific value
- Finding the first element greater than or equal to some number
- Finding the last element less than or equal to some number
- ...


Binary search is both difficult and easy; the implementation has *many details* to watch out for:

- Should `left` and `right` be initialized to $(0,n-1)$ or $(0,n)$?
- Should the `while` condition be `left <= right` or `left < right`?
- Should `mid` be incremented or decremented by $1$ when updating `left` and `right`?


Given these details, binary search has many variants and subtleties. For problem-solving convenience, the following presents a unified approach so you can easily find the correct implementation for any type of problem.

==== Implementation

==== Example: Greater Than or Equal To

*Problem Definition*

Given a *monotonically increasing sequence*, find the index of the first element *greater than or equal to a given value*—defined as the "lower bound". If the lower bound does not exist, return the length of the array.

*Approach*

Given the array `[1,2,4,5,5,6,7]`, with the target value $5$, the lower bound should be $3$.

#table(columns: 7, stroke: .5pt, inset: 5pt,
  [0],
  [1],
  [2],
  [$arrow.r$3],
  [4],
  [5],
  [6],
  [1],
  [2],
  [4],
  [$arrow.r$5],
  [5],
  [6],
  [7],
)

We can see the sequence can be split into *a right side where all elements are >= the target* and *a left side where all elements are < the target*. The index we return is exactly the *lower bound of the subsequence that is >= the target*.

First, we express the approach using a *closed interval*:

- The interval range is `[left, right]`, with `left` pointing to index $0$ and `right` pointing to index $6$.
- `mid` is the midpoint of `[left, right]`.
- *When `left > right`, the interval is empty.*


Based on this approach, the algorithm steps are:

+ If `arr[mid] >=` the target, then all elements in `[mid, right]` are >= the target, so move right leftward: *`right = mid - 1`*.
+ Otherwise, all elements in `[left, mid]` are < the target, so move left rightward: *`left = mid + 1`*.
+ Repeat until the interval is empty. *At this point `left` will be at the lower bound, so return `left`.*


*Code*

You can run the following code to aid your understanding.

#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
#define ll long long
using namespace std;
int a[100005];
int main(){
    int n,x;

    cin>>n;
    for(int i=0;i<n;++i)cin>>a[i];
    cin>>x;
    sort(a,a+n);

    int left=0,right=n-1;// closed interval [0~N-1]
    while(left<=right){// end when [left~right] has size zero
        int mid=(right+left)/2;
        //cout<<left<<' '<<mid<<' '<<right<<'\n';
        if(a[mid]>=x) right=mid-1;
        else left=mid+1;
    }

    cout<<left<<'\n';// return the index
    return 0;
}
```
]

==== Example: Less Than or Equal To

*Problem Definition*

Given a *monotonically increasing sequence*, find the index of the last element *less than or equal to a given value*—defined as the "upper bound".

*Approach*

Given the array `[1,2,4,5,5,6,7]`, with the target value $5$, the upper bound should be $4$.

#table(columns: 7, stroke: .5pt, inset: 5pt,
  [0],
  [1],
  [2],
  [3],
  [$arrow.r$4],
  [5],
  [6],
  [1],
  [2],
  [4],
  [5],
  [$arrow.r$5],
  [6],
  [7],
)

We can similarly split the sequence into a right side (all > the target) and a left side (all <= the target). By observation, *the upper bound of the <= side and the lower bound of the > side are adjacent*, so *upper bound $=$ lower bound $- 1$*. Therefore, every upper-bound problem can be *converted into the "complementary" lower-bound problem*.

- The interval range is `[left, right]`, with `left` pointing to index $0$ and `right` pointing to index $6$.
- `mid` is the midpoint of `[left, right]`.
- *When `left > right`, the interval is empty.*
- This time we are searching for elements strictly greater than the target, so *change the `right` condition to `a[mid] > x`*.


Applying the same algorithm steps as before:
+ If `arr[mid] >=` the target, all elements in `[mid, right]` are >= the target, so move right leftward: *`right = mid - 1`*.
+ Otherwise, all elements in `[left, mid]` are < the target, so move left rightward: *`left = mid + 1`*.
+ Repeat until the interval is empty. *At this point `left` is at the lower bound and `right` is at `left - 1`, which is the "upper bound", so return `right`.*


#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
#define ll long long
using namespace std;
int a[100005];
int main(){
    int n,x;

    cin>>n;
    for(int i=0;i<n;++i)cin>>a[i];
    cin>>x;
    sort(a,a+n);

    int left=0,right=n-1;// closed interval [0~N-1]
    while(left<=right){// end when [left~right] has size zero
        int mid=(right+left)/2;
        //cout<<left<<' '<<mid<<' '<<right<<'\n';
        if(a[mid]>x) right=mid-1;
        else left=mid+1;
    }

    cout<<right<<'\n';// return the index
    return 0;
}
```
]

==== Summary
Whether finding the lower bound or the upper bound, binary search can always be implemented using the "find the lower bound" approach.

==== C++ Binary Search Functions

$1.$ `lower_bound(begin,end,num,greater())`

Binary-searches the range `[begin, end-1)` for the first number less than or equal to `num`. Returns the address of that number if found; otherwise returns `end`.

#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
#define ll long long
using namespace std;
int a[100005];
int main(){
    int n,x;
    cin>>n;
    for(int i=0;i<n;++i)cin>>a[i];
    cin>>x;
    cout<<lower_bound(a,a+n,x)-a<<'\n';
    // Subtract the starting address begin from the returned address to get the index
    return 0;
}
```
]

$2.$ `upper_bound(begin,end,num,greater())`

Binary-searches the range `[begin, end-1)` for the first number less than `num`. Returns the address of that number if found; otherwise returns `end`.

#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
#define ll long long
using namespace std;
int a[100005];
int main(){
    int n,x;
    cin>>n;
    for(int i=0;i<n;++i)cin>>a[i];
    cin>>x;
    cout<<upper_bound(a,a+n,x)-a<<'\n';
    // Subtract the starting address begin from the returned address to get the index
    return 0;
}
```
]

$3.$ `binary_search(begin,end,num,greater())`

Binary-searches the range `[begin, end-1)` to check whether `num` exists in the array. Returns `True` if found; otherwise returns `False`.

#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
#define ll long long
using namespace std;
int a[100005];
int main(){
    int n,x;
    cin>>n;
    for(int i=0;i<n;++i) cin>>a[i];
    cin>>x;
    cout<<upper_bound(a,a+n,x)-a<<'\n';
    // Subtract the starting address begin from the returned address to get the index
    return 0;
}
```
]

=== Examples and Practice
==== Problem: Beauty of Brute Force

*Problem Statement*

Given an array, find the smallest value that is greater than $m$.

*Input Format*

The first line contains two positive integers $n, m$.
The next line contains $n$ positive integers.

$n <= 10^7$

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 3`#linebreak()`6 3 7 5 1`], [`5`],
  [Sample Input 2], [Sample Output 2],
  [`10 3`#linebreak()`5 3 7 5 1 7 5 3 8 4`], [`4`],
)

#tip[
Binary search would actually fail to pass here! Think about why. That's right — because $log(n)$ is over $20$ in this case!
]

==== Problem: `APCS_2022/1` 4. Wall Posters

*Problem Statement*

There is a fence consisting of $n$ planks, each with heights $h_1, h_2, dots.c , h_n$. There are $k$ posters to be placed on the fence; the width of each poster is $w_1, w_2, dots.c w_k$ and all have height $1$.
To place posters at height $x$, the $i$-th poster must be placed on a contiguous segment of $w_i$ planks all with height at least $x$. All posters must be placed at the same height, in order, and without overlapping (adjacent placement is allowed). Find the maximum height at which all posters can be placed.

*Input Format*

The first line contains two positive integers $n, k$.
The next line contains $n$ positive integers representing the height of each plank.
The last line contains $k$ positive integers representing the width of each poster.

$n <= 2 times 10^5$, $k <= 5000$, $h_i <= 10^9$, $sum(w_i) <= n$

*Output Format*

Output 1 line containing 1 integer representing the maximum height.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 1`#linebreak()`6 3 7 5 1`#linebreak()`3`], [`3`],
  [Sample Input 2], [Sample Output 2],
  [`10 3`#linebreak()`5 3 7 5 1 7 5 3 8 4`#linebreak()`2 2 1`], [`5`],
)
