#import "../../template.typ": *

== 預建構函數
有時候會出現的*常用*函數(式)。

#code(title: [可能會用的函數])[
```cpp
void amax(ll &a,ll b){ if(a<b) a=b; }
void amin(ll &a,ll b){ if(a>b) a=b; }

void pmod(ll &a,ll b){ a=(a+b)%MOD; }
void mmod(ll &a,ll b){ a=(a-b)%MOD; }
void tmod(ll &a,ll b){ a=(a*b)%MOD; }

ll POW(ll x,ll a){
    ll ret=1;
    while(a>0){
        if(a&1) tmod(ret,x);
        tmod(x,x);
        a>>=1;
    }
    return ret;
}

void dmod(ll &a,ll b){
    a=a*POW(b,MOD-2)%MOD;
}
```
]

=== 重載運算子
通常用在`set/map/priority_queue`。
#code(title: [運算子重載])[
```cpp
struct info{
    int a,b;
};
// customize freely below
bool operator<(info x,info y){
    if(x.a!=y.a) return x.a<y.a;
    return x.b<y.b;
}

priority_queue<info> pq;
```
]
