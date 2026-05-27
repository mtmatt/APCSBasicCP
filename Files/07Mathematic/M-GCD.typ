#import "../../template.typ": *

== Euclidean Algorithm
=== Concepts
You probably learned this in middle school. It repeatedly takes remainders and swaps positions.

#code(title: [GCD])[
  ```cpp
int gcd(int a,int b){
    return a==0 ? b : gcd(b,a%b);
}
  ```
]

=== Bézout's Theorem
For all $a \, b in bb(Z)$, there exist $x \, y in bb(Z)$ such that $a x + b y = gcd \( a \, b \)$.

=== Extended Euclidean Algorithm
Also known as the Extended Euclidean algorithm. It finds $x$ and $y$ such that $a x + b y = gcd \( a \, b \)$.

How? Imagine $a = 0 \, med b = k$, then set $\( x \, y \) = \( 0 \, 1 \)$, which satisfies $a x + b y = gcd \( a \, b \)$.

For $a eq.not 0$, since $gcd \( a \, med b \) = gcd \( b \, med a % b \)$,

we have

$ g c d \( a \, b \) & = b times x + \( a % b \) times y\
 & = b times x + \( a - floor.l a / b floor.r times b \) times y\
 & = a times \( y \) + b times \( x - floor.l a / b floor.r times y \)\
\( x' \, med y' \) & = \( y \, med x - floor.l a / b floor.r times y \) $

#code(title: [Extended GCD])[
  ```cpp
// ax + by = gcd(a, b)
int extgcd(int a,int b,int &x,int &y){
    if(b==0){
        x=1;
        y=0;
        return y;
    }

    int xp,yp;
    int ret = extgcd(b, a%b, xp, yp); // xp * b + ap * (a%b) = gcd(a, b)

    x = yp;
    y = xp - yp * (a / b);
    return ret;
}
  ```
]

Finding one solution lets us find all solutions: if $a x + b y = gcd \( a \, med b \)$, then $a \( x + k b \) + b \( y - k a \) = gcd \( a \, med b \)$ for any $k in bb(Z)$.
