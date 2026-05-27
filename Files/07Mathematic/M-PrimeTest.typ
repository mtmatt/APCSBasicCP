#import "../../template.typ": *

== 質數判斷
=== 簡單算法
就是從1跑到n-1，看看有沒有可以整除n的數。

=== 小進步
#block[
$N = a b$ and $a \, b in bb(N)$
$arrow.r.double m i n \( a \, b \) lt.eq sqrt(N)$

]
因此，我們可以跑$\[ 1 \, sqrt(N) \]$就好。

#code(title: [$sqrt(N)$ 質數判斷])[
  ```cpp
using ll=long long;
bool IsPrime(ll n){
    for(ll i=2;i*i<=n;++i){
        if(n%i==0){
            return false;
        }
    }
    return true;
}
  ```
]

=== 埃氏篩法
國小應該就有教過？簡單說就是2是質數，所以把2的所有倍數刪掉，接著往後找，第一個沒被刪的數為3，所以一樣把所有3的倍數刪除，依此類推。

實作上我們會使用bitset，如果要省記憶體。使用bool陣列，如果要快。(聽起來矛盾是吧，其實沒有，bitset快的只有位元運算)。

複雜度為$N / 2 + N / 3 + N / 5 + N / 7 + dots.h.c$，其中N是篩的範圍。經過通靈(我不會證明的簡稱)我們得知其複雜度為$O \( n log log n \)$。

關鍵字 Sum of reciprocals(倒數) of primes。

#code(title: [埃氏篩法])[
  ```cpp
using ll=long long;
const int N=1e7+10
bitset<N> isp;

void eratosthenes(){
    isp.set();
    isp[0]=isp[1]=false;

    for(ll i=2; i*i<=N; i++){
        if(isp[i]){
            for(ll j=i*i;j<=N;j+=i){
                isp[j]=false;
            }
        }
    }
}
  ```
]

=== Millar-Rabin
神奇的東東，貼個程式碼就好，我也不知道原理。但複雜度為$O \( log^3 \( n \) \)$。

#code(title: [Millar-Rabin 質數判斷])[
  ```cpp
// n < 4,759,123,142        {3 : 2, 7, 61}
// n < 1,122,004,669,633    {4 : 2, 13, 23, 1662803}
// n < 3,474,749,660,383    {6 : primes <= 13}
// n < 2^64  {7 : 2, 325, 9375, 28178, 450775, 9780504, 1795265022}
bool millerRabin(ll n, ll a) {
    if (n < 2) return 0;
    if ((a = a%n) == 0) return 1;
    if (n & 1 ^ 1) return n == 2;

    ll tmp = (n - 1) / ((n - 1) & (1 - n));
    ll t = log2((n - 1) & (1 - n)), x = 1;
    for (; tmp; tmp >>= 1, a = a*a%n)
        if (tmp & 1) x = x * a % n;
    if (x == 1 || x == n - 1) return 1;
    while (--t)
        if ((x = x*x%n) == n - 1) return 1;
    return 0;
}
  ```
]

=== 應用
我們可以利用以上的質數篩選法進行質因數分解，以埃氏篩法為例，如果我們的陣列改存其中一個可以整除他的數，那我們就可以在$O \( log n \)$的時間內完成質因數分解。

#code(title: [埃氏篩法])[
  ```cpp
const int N=1e6+10;
using ll=long long;
int div[N];

void init(){
    for(int &a:div) a=-1;
    div[0]=div[1]=0;

    for(ll i=2; i*i<=N; i++){
        if(div[i]=-1){
            div[i]=i;
            for(ll j=i*i;j<=N;j+=i){
                div[j]=i;
            }
        }
    }
}

// This function returns a map containing all prime factors of q and their exponents.
// However, this also adds an extra log factor to the time complexity.
map<int,int> PrimeFactor(int q){
    map<int,int> ret;
    while(q>0){
        ret[div[q]]++;
        q/=div[q];
    }
    return ret;
}

// The first is the prime factor, and the second is the power.
void output(map<int,int> &mp){
    for(auto &p:mp){
        cout<<p.first<<" "<<p.second<<"\n";
    }
}
  ```
]
