#import "../../template.typ": *

== 輾轉相除法
=== 概念
應該國中學過？就是反覆取餘數，然後交換位置。

#code(title: [GCD])[
  ```cpp
int gcd(int a,int b){
    return a==0 ? b : gcd(b,a%b);
}
  ```
]

=== Bézout's Theorem
貝祖定理。對於所有$a, b in bb(Z)$，存在$x,y in bb(Z)$滿足$a x + b y = gcd \( a \, b \)$。

=== 擴展輾轉相除法
又稱為Extended Euclidean algorithm。可以找到$a x + b y = gcd \( a \, b \)$。

怎麼找呢？想像$a = 0 \, med b = k$，則可以設$\( x \, y \) = \( 0 \, 1 \)$，如此一來就會滿足$a x + b y = gcd \( a \, b \)$。

對於$a eq.not 0$的情況，因為$gcd \( a \, med b \) = gcd \( b \, med a % b \)$，

所以

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

求出一組解就可以求出所有解，因為如果$a x + b y = gcd \( a \, med b \)$，則$a \( x + k b \) + b \( y - k a \) = gcd \( a \, med b \)$，其中$k in bb(Z)$。
