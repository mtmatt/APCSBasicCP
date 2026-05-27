#import "../../template.typ": *

== 模運算
就是跟餘數有關的東西。

=== 同餘
$a equiv b med \( mod med m \)$，我們稱為$a$ 同餘於 $b$ 模 $m$。
例如$9 equiv 1 med \( mod med 4 \)$，$9 equiv - 3 med \( mod med 4 \)$。

定義上，$a equiv b med \( mod med m \)$ 等價於 $m divides \( a - b \)$
$arrow.l.r.double a = b + m z med \( z in bb(Z) \)$

=== 基本運算
$\( A + B \) % m = \( A % m + B % m \) % m$

$\( A - B \) % m = \( A % m - B % m + m \) % m$

$\( A times B \) % m = \( \( A % m \) times \( B % m \) \) % m$

那除法呢？

=== 模逆元
又稱為模反元素，是個有魔法的東西(誤)。

如果 $a x equiv 1 med \( mod med m \)$，則 $x$ 是 $a$ 模 $m$ 下的模逆元，
記為 $x equiv a^(- 1) med \( mod med m \)$，不過要注意的是他不是分數喔。

$\( a div b \) med \( mod med m \)$ 可以視為 $arrow.r.double \( a times b^(- 1) \) med \( mod med m \)$。

至於要怎麼找，我們有兩個方法。

==== 費馬小定理

$a in bb(Z)$, $p$ 是質數，
則$a^p equiv a med \( mod med p \)$，經過基本代數運算後，可以得到
$a^(p - 2) equiv a^(- 1) med \( mod med p \)$

證明：#link("https://hackmd.io/@Ccucumber12/Hy8nj-fxt#/3/10") 。

實作用快速冪，可以得到$O \( log p \)$複雜度解法。

==== EXT GCD

$a x + b y = gcd \( a \, b \)$ 首先找出 $a x = 1 med \( mod med p \)$，
這將導致 $a x - 1 = p z$，也就是$a x - p z = 1$
$arrow.r.double a x + p z = g c d \( a \, p \)$
