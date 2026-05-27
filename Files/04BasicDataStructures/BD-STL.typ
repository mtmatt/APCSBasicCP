#import "../../template.typ": *

== STL
雖然至今為止我們都當作你們已經會使用STL了。不過可能有一些同學甚至還不知道我在講什麼。所以我決定加上這個小節，告訴大家什麼是STL。

*不過其實這個章節的作者是戴偉璿*

#align(right)[_作者: 戴偉璿_]

=== 什麼是STL

又稱為Standard Template Liberty。

- 可以裝資料的容器
- 刻好的模板，方便我們使用


=== string

#code(title: [string 用法])[
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

#code(title: [vector 用法])[
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

#code(title: [stack 用法])[
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

#code(title: [queue 用法])[
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

雙端佇列 (Deque)，上一章有用到。

#code(title: [deque 用法])[
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

本質上是一個使用Vector維護的堆疊 (Heap) 資料結構。

#code(title: [priority queue 用法])[
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
Map與Set都是使用紅黑樹實作的資料結構，那是一種稱為平衡樹的資料結構。未來在進階資料結構時會提到一種稱為Treap的平衡樹。

#code(title: [map 用法])[
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

#code(title: [set 用法])[
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
Bitset在做位元運算時會比bool陣列快上許多。所以有時候會用到，但真的很少需要它。

#code(title: [bitset 用法])[
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

=== 小節
這個章節基本上都是背誦的內容，但是其實用性非常高，建議同學藉由實作上多多使用這些東西來熟悉STL們。

#tip[
不要用背的，而是藉由不斷的使用讓大腦自然地記起來。
]

=== 範例與練習

==== 範例與練習：LeetCode 3. Longest Substring Without Repeating Characters

*題目敘述*

給你一個字串 s，找出最長的子字串滿足裡面沒有相同的字母。

*輸入說明*

`0 <= s.length <= 5 * 10^4`
s裡面可能有空格。

*輸出說明*

輸出長度。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [範例輸入 1], [範例輸出 1],
  [`abcabcbb`], [`3`],
  [範例輸入 2], [範例輸出 2],
  [`bbbbb`], [`1`],
  [範例輸入 3], [範例輸出 3],
  [`pwwkew`], [`3`],
)
