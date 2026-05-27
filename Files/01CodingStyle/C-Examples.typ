#import "../../template.typ": *

== 範例與練習
==== 範例：快速冪。

#code(title: [Formatting example])[
```cpp
using ll=long long;
const ll MOD=1e9+7;

ll POW(ll a,ll x){
    ll ret=1;
    while(x>0){
        if(x%2==1) ret=ret*a%MOD;
        a=a*a%MOD;
        x/=2;
    }
    return ret;
}
```
]

==== 問題：請對以下程式碼排版。
#code(title: [Code])[
```cpp
#include<bits/stdc++.h>
using namespace std;

using ll=long long;
const ll INF=0x3f3f3f3f;
const ll LINF=0x3f3f3f3f3f3f3f3f;
const ll MOD=1e9+7;

int n;
int dp[20][(1<<16)+10];
int a[20];
int main(){
ios::sync_with_stdio(0);cin.tie(0);cin>>n;
for(int i=1;i<=n;++i) cin>>a[i];
for(int i=1;i<=n;++i) dp[i][0]=0;
for(int i=1;i<(1<<n);++i){
for(int k=1;k<=n;++k){
for(int l=1;l<=n;++l){
if( (i-(1<<l))^i == (1<<k) ){dp[k][i];
}}
}}
}
```
]
