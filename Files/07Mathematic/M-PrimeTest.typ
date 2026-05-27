#import "../../template.typ": *

== Primality Testing
=== Naive Algorithm
Simply iterate from 1 to n-1 and check whether any number divides n evenly.

=== A Small Improvement
#block[
$N = a b$ and $a \, b in bb(N)$
$arrow.r.double m i n \( a \, b \) lt.eq sqrt(N)$

]
Therefore, we only need to iterate over $\[ 1 \, sqrt(N) \]$.

#code(title: [sqrt(N) Primality Test])[
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

=== Sieve of Eratosthenes
You probably learned this in elementary school. In short: 2 is prime, so remove all multiples of 2. Then move forward — the first number not yet removed is 3, so remove all multiples of 3. Repeat.

In practice, we use a bitset if we want to save memory, or a bool array if we want speed. (That sounds contradictory, but it isn't — bitset is only faster for bitwise operations.)

The complexity is $N / 2 + N / 3 + N / 5 + N / 7 + dots.h.c$, where N is the sieve range. Through some mathematical magic (which I won't prove) we know the complexity is $O \( n log log n \)$.

Keyword: Sum of reciprocals of primes.

#code(title: [Sieve of Eratosthenes])[
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

=== Miller-Rabin
A magical algorithm — just paste the code and use it; I don't know how it works either. But the complexity is $O \( log^3 \( n \) \)$.

#code(title: [Miller-Rabin Primality Test])[
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

=== Applications
We can use the prime sieve above to perform prime factorization. Taking the Sieve of Eratosthenes as an example: if we change the array to store one divisor of each number, we can complete prime factorization in $O \( log n \)$ time.

#code(title: [Sieve of Eratosthenes])[
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
