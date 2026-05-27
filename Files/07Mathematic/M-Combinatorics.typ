#import "../../template.typ": *

== Combinatorics
=== Concepts
This is the combinatorics part of permutations and combinations, so we already know these formulas. Let's first introduce the notation, even though it may not come up right away.

$ binom(n, k) = C_k^n = frac(n !, k ! \( n - k \) !)\
binom(n, k) = binom(n - 1, k) + binom(n - 1, k - 1) $

Because of these two formulas, we have two ways to compute $binom(n, k)$.

#code(title: [Compute C(n, k)])[
  ```cpp
using ll=long long;
const ll MOD=1e9+7;

ll POW(ll a,ll x){
    ll ret=1;
    while(x>0){
        if(x&1) ret=(ret*a)%MOD;
        a=(a*a)%MOD;
        x>>=1;
    }
    return ret;
}

ll stair(int n){
    ll ret=1;
    for(int i=2;i<=n;++i){
        ret=(ret*i)%MOD;
    }
    return ret;
}

// Time complexity is approximately O(n log MOD)
// but can be improved to O(1) by precomputing a table of a! and its inverses
ll C(int n,int k){
    ll ret=stair(n);
    ret=(ret*POW(stair(k),MOD-2));
    ret=(ret*POW(stair(n-k),MOD-2));
    return ret;
}

// Time complexity O(NK), but generates a table for querying any dp[n][k].
const int N=1005,K=1010;
ll dp[N][K];
void C2(){
    for(int i=1;i<N;++i){
        dp[i][0]=1;
    }

    for(int i=1;i<N;++i){
        for(int j=1;j<=i;++j){
            dp[i][j]=dp[i-1][j]+dp[i-1][j-1];
        }
    }
}
  ```
]
