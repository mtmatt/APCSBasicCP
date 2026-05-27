#import "../../template.typ": *

== Binary Exponentiation
=== Introduction
When you see "binary exponentiation," you might first wonder: "What is exponentiation?"

The answer is powers—things of the form $a^x$. In general, one might think computing $a^x$ takes $O(x)$ time, since it requires $n-1$ multiplications. The code is as follows.

#code(title: [Naive Exponentiation])[
```cpp
int POW(int a,int x){
    int ret=1;
    for(int i=0;i<x;++i){
        ret*=a;
    }
    return ret;
}
```
]

=== Concept
We can actually reduce the number of required operations, especially when $x=2^k, k in \N$. Because we can compute $a^2$ from $a times a$,
then $a^4$ from $a^2 times a^2$, and so on—we only need $O(log(x))$ time.

But what if $n in.not \N$ when computing $a^n$? No worries; we can still compute the answer using a similar approach in no more than $O(log(n))$ time.
We can convert $n$ to binary; for example, $10_((10))$ can be represented as $1010_((2))$. To compute $a^(10)$, using the approach above we can obtain $a^2$ and $a^8$.
Finally, multiply the two together: $a^(10)$ achieved!

=== Implementation
In implementation we can use a while loop or recursion. Since the loop has a smaller constant, I use it more often. In practice you probably won't get TLEd on constants alone, so either is fine.

#code(title: [Iterative Binary Exponentiation])[
```cpp
int POW(int a,int x){
    int ret=1;
    while(x>0){
        if(x&1){// => if(x%2==1)
            ret*=a;
        }
        a*=a;
        x>>=1;// => x/=2;
    }
}
```
]

This code repeatedly uses \verb|x

=== Applications
In general, the numbers computed by binary exponentiation are extremely large—too large even for `long long`. So what is the practical use? In competitive programming, problems usually ask you to take the result modulo some number, typically $10^(9)+7$. I prefer using a constant rather than a macro.

#code(title: [Code])[
```cpp
using ll=long long;
const ll MOD=1e9+7;
```
]

=== Examples and Practice
==== Problem: Implement binary exponentiation using recursion.

==== Problem: Implement binary exponentiation for $(a + b sqrt(2))^n$.

==== Problem: Implement binary exponentiation for $(a sqrt(2) + b sqrt(6))^n$.

==== Example: Design an $O(n log(n))$ algorithm for computing the Fibonacci sequence.

For this problem, first consider that to compute $a_n$ we need $a_(n-1)$ and $a_(n-2)$.
We can therefore use a matrix to represent the recurrence relation between adjacent terms.

$ mat(delim: "[", a_n; a_(n - 1)) = mat(delim: "[", 1, 1; 1, 0) times mat(delim: "[", a_(n - 1); a_(n - 2)) $

This matrix multiplication expresses two things: first, $a_n=1 times a_(n-1)+1 times a_(n-2)$; second, $a_(n-1)=1 times a_(n-1)+0 times a_(n-2)$.

What is the benefit of this representation? Indeed, since

$ mat(delim: "[", a_n; a_(n - 1)) = mat(delim: "[", 1, 1; 1, 0) times mat(delim: "[", a_(n - 1); a_(n - 2)) $

then

$ mat(delim: "[", a_n; a_(n - 1)) = mat(delim: "[", 1, 1; 1, 0)^2 times mat(delim: "[", a_(n - 2); a_(n - 3)) $

Repeating this $n-2$ times, we get:

$ mat(delim: "[", a_n; a_(n - 1)) = mat(delim: "[", 1, 1; 1, 0)^(n - 2) times mat(delim: "[", a_2; a_1) = mat(delim: "[", 1, 1; 1, 0)^(n - 2) times mat(delim: "[", 1; 1) $

Before implementing, we first handle matrix multiplication, which can be done as follows.

#code(title: [Matrix Multiplication $O(n^3)$])[
```cpp
using ll=long long;
using vec=vector<ll>;
using Mer=vector<vec>;
const ll MOD=1e9+7;

Mer operator*(Mer a,Mer b){
    Mer ret(a.size(),vll(b[0].size()));
    for(int i=0;i<a.size();++i){
        for(int j=0;j<b[0].size();++j){
            for(int k=0;k<a.size();++k){
                ret[i][j]=(ret[i][j]+a[i][k]*b[k][j])%MOD;
            }
        }
    }
    return ret;
}
```
]

When implementing with a loop, be careful about the identity matrix form, otherwise errors will occur.

#code(title: [Matrix Binary Exponentiation])[
```cpp
Mer POW(Mer a,ll x){
    Mer ret(a.size(),vll(a[0].size(),0));
    for(int i=0;i<a.size();++i) ret[i][i]=1;
    while(x>0){
        if(x&1) ret=ret*a;
        a=a*a;
        x>>=1;
    }
    return ret;
}
```
]

With this tool in hand, computing the Fibonacci sequence becomes easy. We can readily solve the problem using POW.

#code(title: [Fibonacci Sequence $O(log(n))$ Algorithm])[
```cpp
int calculate(ll n){
    Mer t={
        {1,1},
        {1,0}
    };

    t=POW(t,n-2);

    Mer ori={
        {1},
        {1}
    };

    Mer ans=t*ori;

    return ans[0][0];
}
```
]

==== Problem: Given a sequence $a$ satisfying the recurrence below, express its matrix transition form.

$ a_1 = 1, a_2 = 2 \
  a_n = x times a_(n - 1) + y times a_(n - 2), n >= 2 $

==== Problem: 1st Excellence Cup E. Steal A Safe

*Problem Statement*

The partial-score master of YiZhong now wants to steal something different. To prove his skill, he decides to steal a safe containing only a mug with "ZhuoYue" written on it. The safe is a cube, roughly as shown in the figure.

#align(center)[#image("../Images/StealASafe.png", width: 100%)]

There is a combination lock on it (forgive me for not being able to draw it), but no reset button, so he believes the code is fixed. He then notices something pyramid-like on the side of the safe made of a different metal. Looking through an electron microscope, he discovers a regular pattern. With his limited computational ability, he is sure he would make mistakes. Also, the pyramid has too many layers and grows very quickly, discouraging him from computing by hand. Since he cannot program, he asks for your help.

To save you time (there are more problems ahead), he has already written out the recurrence relation as follows.

```text
\begin{cases}
S_1=x_1, \, S_2=x_2\\
S_n=a times S_{n-1} + b times S_{n-2} + cn^2 + d times 2^n\\
\end{cases}
```

It is obvious that the numbers will be very large, so he guesses you may need to take the result modulo some number. Since the designer of the safe is a veteran who frequently wins at `ICPC`, he guesses the modulus $(M)$ is either $10^9+7$ or $998244353$. Please compute the number of atoms at layer $n$ (remember to take the result modulo $M$).

*Input Format*

The first line contains $t$.
The following $t$ lines each contain $8$ numbers: $x_1   x_2   a   b   c   d   n   M$ as described above.

$t <= 10^3$

$x_1,   x_2 <= 10^3$

$a,   b,   c,   d <= 100$

$n <= 10^(12)$

$M in(  10^9+7,998244353  )$

*Output Format*

Output $t$ numbers $S_n$ (remember to take the result modulo $M$), one per line.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`1`#linebreak()`1 1 1 1 0 0 3 1000000007`], [`2`],
  [Sample Input 2], [Sample Output 2],
  [`2`#linebreak()`727 434 77 62 32 82 977211338887 1000000007`#linebreak()`1 1 2 3 2 1 3 1000000007`], [`857215810`#linebreak()`31`],
)
