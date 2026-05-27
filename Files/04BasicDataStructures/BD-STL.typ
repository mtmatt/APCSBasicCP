#import "../../template.typ": *

== STL
Although up to this point we have been assuming you already know how to use the STL, some students may still not know what we are talking about. So I decided to add this section to explain what the STL is.

*Actually, the author of this section is Wei-Xuan Dai*

#align(right)[_Author: Wei-Xuan Dai_]

=== What is the STL

Also known as the Standard Template Library.

- Containers that can hold data
- Pre-built templates that make our lives easier


=== string

#code(title: [string usage])[
```cpp
// declare
string s;

// give value / input
cin>>s;
getline(cin,s); // reads an entire line

// find one index
s[5];

// size / length
// good
cout<<s.size()<<s.length();
// bad
cout<<strlen(s);

// clear
s.clear();
```
]

=== vector

#code(title: [vector usage])[
```cpp
// declare
vector<int> v;
vector<char> v[10005];// this declares 10005 vectors
// not a single vector with 10005 elements
// if you need a vector with 10005 elements:
vector<int> v(10005);
vector<int> v(10005,-1); // all elements initialized to -1

// add element
// faster — uses constructor instead of copy
v.emplace_back(x);
// slower
v.push_back(x);

// erase back — remove the last element
v.pop_back()

// go through / iterate
for(auto i:v){
    // i: the elements of vector v
}

// size
v.size()

// clear
v.clear();
```
]

=== stack

#code(title: [stack usage])[
```cpp
// declare
stack<int> st;
stack<char> st;
// faster
stack<int,vector<int>> st;

// add element to back — equivalent to push_back()
st.push(x);
st.emplace(x); // like emplace_back() in vector

// query the top element
st.top();

// remove the top element
st.pop();

// check is empty
st.empty();

// size
st.size()
```
]

=== queue

#code(title: [queue usage])[
```cpp
// declare
queue<int> qu;

// add element to back
qu.push(x);

// query the first element
qu.front();

// remove the front element
qu.pop();

// check is empty
qu.empty();

// size
qu.size()
```
]

=== deque

Double-ended queue, used in the previous chapter.

#code(title: [deque usage])[
```cpp
// declare
deque<int> dq;

// add element to back or front
dq.push_back(x);
dq.push_front(x);

// query the front or back element
dq.front();
dq.back();

// remove from back or front
dq.pop_back();
dq.pop_front();

// can also be accessed like an array
dq[10];

// check is empty
dq.empty();

// size
dq.size()
```
]

=== priority queue

Essentially a heap data structure maintained using a vector.

#code(title: [priority queue usage])[
```cpp
// declare (max heap)
priority_queue<int> pq;
// min heap
priority_queue<int,vector<int>,greater<int>> pq;

// add element into the pq
pq.push(x);

// query the top element (the maximum for a max heap)
// (the minimum for a min heap)
pq.top();

// remove the max/min element
pq.pop();

// check is empty
pq.empty()

// size
pq.size()
```
]

=== map
Both map and set are data structures implemented using a red-black tree, a type of balanced binary search tree. In the advanced data structures section, we will introduce a type of balanced tree called a Treap.

#code(title: [map usage])[
```cpp
// declare
map<int,int> mp;
// the two types can differ
map<string,int> mp;

// add element into mp (key is y, value is x)
mp.insert({y,x});
mp.emplace(y,x);
mp[y]=x;

// query the element
mp[y];
mp.begin();
mp.end();

// remove the element with key x
mp.erase(x);

// check if the element with key x is present in the map container

// return int (but only 0 or 1)
mp.count(x)

// return iterator
map<int,int>::iterator it=mp.find(x)

// check is empty
mp.empty()

// size
mp.size()
```
]

=== set

#code(title: [set usage])[
```cpp
// declare
set<int> S;

// add element
S.insert(x);
S[y]=x;

// query the element
S[y]
S.begin();
S.end();

// check if x is in the set
// return iterator
set<int>::iterator it=S.find(x)
// return count
S.count(x)

// find the smallest value not less than x
it=S.lower_bound(x);
// find the smallest value greater than x
it=S.upper_bound(x);
// remove the element
S.erase(x);

// check is empty
S.empty()

// size
S.size()
```
]

=== bitset
Bitset is much faster than a bool array for bitwise operations. It can be useful sometimes, but you will rarely need it.

#code(title: [bitset usage])[
```cpp
// declare
bitset<100010> bt;

// give value
string str;
cin>>str;
bt=bitset<100010>(str);

// find one index / access
bt[5];

// set all elements to 0
bt.reset();

// set all elements to 1
bt.set();

// bitwise operation
bitset<10> a,b;
for(auto &i:a) cin>>i;
for(auto &i:b) cin>>i;

cout<<a&b<<"\n";
cout<<a|b<<"\n";
cout<<a^b<<"\n";
```
]

=== Summary
The content of this section is mostly memorization, but it is extremely practical. Students are encouraged to become familiar with the STL by using these structures as much as possible in practice.

#tip[
Do not try to memorize by rote — instead, let your brain naturally remember them through repeated use.
]

=== Examples and Practice

==== Problem: LeetCode 3. Longest Substring Without Repeating Characters

*Problem Statement*

Given a string s, find the longest substring that contains no repeated characters.

*Input Description*

`0 <= s.length <= 5 * 10^4`
s may contain spaces.

*Output Description*

Output the length.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`abcabcbb`], [`3`],
  [Sample Input 2], [Sample Output 2],
  [`bbbbb`], [`1`],
  [Sample Input 3], [Sample Output 3],
  [`pwwkew`], [`3`],
)
