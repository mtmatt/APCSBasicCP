#import "../../template.typ": *

== 巨集和程式碼簡化技巧
我個人其實並沒有大量地使用巨集，但是有許多人喜歡，因此我先列出一些較常用的以供參考。

#code(title: [巨集們])[
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

還有一些我完全沒有在使用的。

#code(title: [更多巨集們])[
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
有人會說，這裡面有些不是巨集，沒有錯，你是對的，不過因為功能近似，所以我在這裡通稱他們巨集。
]
