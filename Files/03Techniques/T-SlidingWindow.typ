#import "../../template.typ": *

== Sliding Window
=== Concept
Sometimes we encounter problems asking us to find the maximum or minimum value of every contiguous subarray of length $k$.
In such cases, we can use the sliding window technique.

The sliding window technique focuses on elements entering and leaving the window. For the maximum value, we can maintain a double-ended queue (deque).
This deque stores element indices in decreasing order of their values.

Using the table below as an example, assume $k=4$.

#table(columns: 7, stroke: .5pt, inset: 5pt,
  [Array Index],
  [1],
  [2],
  [3],
  [4],
  [5],
  [6],
  [Array Element],
  [5],
  [2],
  [4],
  [-3],
  [-1],
  [9],
)

The maximum of the interval $1$-$4$ is $5$.
The maximum of interval $2$-$5$ is $4$, and so on.

We can handle the maximum of each interval by operating on the deque.

#code(title: [Maintaining a Maximum-Value Deque])[
```cpp
const int N=100010;
int a[N];
deque<int> dq;

void op(int n,int k){
    while(dq.front()<n-k){
        dq.pop_front();
    }

    while(a[dq.back()]<a[n]){
        dq.pop_back();
    }

    dq.push_back(n);
}
```
]

The front of the deque stores the index of the maximum value. By repeating these steps we can answer maximum queries for all intervals. I will omit the full algorithm listing here.

=== Complexity
Looking at the nested loops in the complete algorithm, one might assume the complexity is $O(n^2)$,
but that is not the case, because each element enters and leaves the deque at most once.
So the amortized time complexity is $O(n)$.

The sliding window technique typically reduces the complexity because we focus only on element entry and exit. This same idea will appear again in the advanced topic of Mo's algorithm.
This problem can also be solved with a `priority_queue`, but the time complexity would increase to $O(n log(n))$.

=== Examples and Practice

==== Problem: Longest Non-Repeating Subarray

*Problem Statement*

Given an array of length $n$, find the longest contiguous subarray
such that no two elements within the subarray are the same.

*Input Format*

The first line contains a number $n$.

The second line contains $n$ numbers representing the array.

*Output Format*

Output a single number representing the length of the subarray satisfying the condition.

*Sample Tests*

*Output Format*

Output $t$ numbers $S_n$ (remember to take the remainder modulo $M$), one per line.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 2 3 2 1`], [`3`],
  [Sample Input 2], [Sample Output 2],
  [`7`#linebreak()`1 5 3 4 2 5 2 1`], [`5`],
)

==== Problem: Minimum Window Substring

*Problem Statement*

Given a string $S$ and a string $T$, find the minimum substring of $S$ that contains all the characters of $T$.

*Input Format*

The first line contains a string $S$.

The second line contains a string $T$.

*Output Format*

Output the minimum required length.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`ADOBECODEBANC`#linebreak()`ABC`], [`4`],
)

#tip[
It is recommended that students revisit this section after studying data structures — you may gain new insights.
]
