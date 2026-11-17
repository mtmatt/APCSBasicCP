#import "../../template.typ": *

== STL

雖然至今為止我們都當作你們已經會使用STL了。不過可能有一些同學甚至還不知道我在講什麼。所以我決定加上這個小節，告訴大家什麼是STL。

#strong[不過其實這個章節的作者是戴偉璿]

#set-author("戴偉璿")

=== 什麼是STL

又稱為Standard Template Liberty。

- 可以裝資料的容器

- 刻好的模板，方便我們使用

=== string

#listing([string 用法])[
```cpp
// declare 宣告
string s;

// give value 輸入
cin>>s;
getline(cin,s); // 整行的

// find one index
s[5];

// size 長度
// good
cout<<s.size()<<s.length();
// bad
cout<<strlen(s);

// clear 清空
s.clear();
```
]

=== vector

#listing([vector 用法])[
```cpp
// declare 宣告
vector<int> v;
vector<char> v[10005];// 這樣宣告的是10005個vector
// 而不是內有10005個元素的vector
// 如果需要宣告有10005個元素的vector
vector<int> v(10005);
vector<int> v(10005,-1); // 所有元素皆為-1

// add element 新增元素
// faster 因為使用建構式而非複製。
v.emplace_back(x);
// slower
v.push_back(x);

// erase back 從最後一個移除元素
v.pop_back()

// go through 遍歷
for(auto i:v){
    // i:the elements of vector v
}

// size
v.size()
    
// clear
v.clear();
```
]

=== stack

#listing([stack 用法])[
```cpp
// declare 宣告
stack<int> st;
stack<char> st;
// faster
stack<int,vector<int>> st;

// add element to back 就是 push_back()
st.push(x);
st.emplace(x); // emplace_back() in vector

// query the last element 頂部元素
st.top();

// move out the last element 移除頂部元素
st.pop();

// check is empty
st.empty();

// size
st.size()
```
]

=== queue

#listing([queue 用法])[
```cpp
// declare
queue<int> qu;

// add element to back
qu.push(x);

// query the first element
qu.front();

// move out the last element
qu.pop();

// check is empty
qu.empty();

// size
qu.size()
```
]

=== deque

雙端佇列，上一章有用到。

#listing([deque 用法])[
```cpp
// declare
deque<int> dq;

// add element to back
dq.push_back(x);
dq.push_front(x);

// query the last element
dq.front();
dq.back();

// move out the last element
dq.pop_back();
dq.pop_front();

// 也可以像陣列一樣用
dq[10];

// check is empty
dq.empty();

// size
dq.size()
```
]

=== priority queue

本質上是一個使用vector維護的heap資料結構。

#listing([priority queue 用法])[
```cpp
// declare (最大堆)
priority_queue<int> pq;
// 最小堆
priority_queue<int,vector<int>,greater<int>> pq;

// add element into the pq
pq.push(x);

// query the element (對最大堆來說就是最大值)
// (對最小堆來說就是最小值)
pq.top();

// move out the max/min element
pq.pop();

// check is empty
pq.empty()
    
// size
pq.size()
```
]

=== map

map與set都是使用紅黑樹實作的資料結構，那是一種稱為平衡樹的資料結構。未來在進階資料結構時會提到一種稱為Treap的平衡樹。

#listing([map 用法])[
```cpp
// declare
map<int,int> mp;
// 兩個可以不一樣
map<string,int> mp;

// add element into mp (key 為 y，value 為 x)
mp.insert({y,x});
mp.emplace(y,x);
mp[y]=x;

// query the element
mp[y];
mp.begin();
mp.end();

// move out the element (key 為 x)
mp.erase(x);

// check the element with key x is present in the map container

// return int (但只有 0, 1)
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

#listing([set 用法])[
```cpp
// declare
set<int> S;

// add element to back
S.insert(x);
S[y]=x;

// query the element
S[y]
S.begin();
S.end();

// check the x is in the set
// return iterator
set<int>::iterator it=S.find(x)
//return
S.count(x)

// 找出不小於x的最小值
it=S.lower_bound(x);
// 找出大於x的最小值
it=S.upper_bound(x);
// move out the last element
S.erase(x);

// check is empty
S.empty()
    
// size
S.size()
```
]

=== bitset

bitset在做位元運算時會比bool陣列快上許多。所以有時候會用到，但真的很少需要它。

#listing([bitset 用法])[
```cpp
// declare
bitset<100010> bt;

// give value
string str;
cin>>str;
bt=bitset<100010>(str);

// find one index 存取
bt[5];

// set all element to 0
bt.reset();

// set all element to 1
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

#problem[LeetCode 3. Longest Substring Without Repeating Characters]

#strong[題目敘述]

給你一個字串 s，找出最長的子字串滿足裡面沒有相同的字母。

#strong[輸入說明]

$0 lt.eq s . l e n g t h lt.eq 5 times 10^4$ s裡面可能有空格。

#strong[輸出說明]

輸出長度。

#strong[範例測試]

#sample-io(
  "abcabcbb",
  "3",
  input-title: [範例輸入 1],
  output-title: [範例輸出 1],
)
#sample-io(
  "bbbbb",
  "1",
  input-title: [範例輸入 2],
  output-title: [範例輸出 2],
)
#sample-io(
  "pwwkew",
  "3",
  input-title: [範例輸入 3],
  output-title: [範例輸出 3],
)
