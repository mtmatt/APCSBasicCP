#import "../../template.typ": *

== Macros and Code Simplification Techniques
Personally, I don't use macros heavily, but many people like them, so I've listed some of the more commonly used ones here for reference.

#code(title: [Macros])[
```cpp
using namespace std;

// Shorten long long variable declarations and common constants
using ll=long long;
const ll MOD=1e9+7;
const ll INF=0x3f3f3f3f;
const ll LINF=0x3f3f3f3f3f3f3f3f;
const ll N=1000010;
const ll M=1010;
const long double PI=3.14159265358979;

// Macros (contest code-shortening tricks)
#define ALL(v) v.begin(),v.end()
#define siz(v) ((int)v.size())
#define F first
#define S second
#define EB emplace_back
#define PB pop_back
#define EF emplace_front
#define PF pop_front
#define EE emplace
#define rs resize
#define MP make_pair

template<typename T> using prior=priority_queue<T>;
template<typename T> using Prior=priority_queue<T,vector<T>,greater<T>>;
template<typename T> using Stack=stack<T,vector<T>>;
using pii=pair<int,int>;
using pll=pair<ll,ll>;
```
]

There are also some that I never use at all.

#code(title: [More Macros])[
```cpp
using ld=long double;
template<typename T> using Stack=stack<T,vector<T>>;
template<typename T> using uset=unordered_set<T>;
template<typename T> using umap=unordered_map<T>;
template<typename T> using mset=multiset<T>;
template<typename T> using mmap=multimap<T>;
template<typename T> using umset=unordered_multiset<T>;
template<typename T> using ummap=unordered_multimap<T>;
template<typename T> using vit=vector<T>::iterator;
template<typename T> using sit=set<T>::iterator;
template<typename T> using mit=map<T>::iterator;
template<typename T> using usit=uset<T>::iterator;
template<typename T> using umit=umap<T>::iterator;
template<typename T> using msit=mset<T>::iterator;
template<typename T> using mmit=mmap<T>::iterator;
template<typename T> using umsit=umset<T>::iterator;
template<typename T> using ummit=ummap<T>::iterator;
using pdd=pair<ld,ld>;
```
]

#tip[
Some might say that not everything here is actually a macro — and you would be correct. However, since they serve similar purposes, I refer to them all as macros here.
]
