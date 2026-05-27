#import "../../template.typ": *

== Modular Arithmetic
Everything related to remainders.

=== Congruence
$a equiv b med \( mod med m \)$ means $a$ is congruent to $b$ modulo $m$.
For example, $9 equiv 1 med \( mod med 4 \)$ and $9 equiv - 3 med \( mod med 4 \)$.

By definition, $a equiv b med \( mod med m \)$ is equivalent to $m divides \( a - b \)$
$arrow.l.r.double a = b + m z med \( z in bb(Z) \)$

=== Basic Operations
$\( A + B \) % m = \( A % m + B % m \) % m$

$\( A - B \) % m = \( A % m - B % m + m \) % m$

$\( A times B \) % m = \( \( A % m \) times \( B % m \) \) % m$

What about division?

=== Modular Inverse
Also known as the modular multiplicative inverse — a somewhat magical concept.

If $a x equiv 1 med \( mod med m \)$, then $x$ is the modular inverse of $a$ modulo $m$, written as $x equiv a^(- 1) med \( mod med m \)$. Note that this is not a fraction.

$\( a div b \) med \( mod med m \)$ can be viewed as $arrow.r.double \( a times b^(- 1) \) med \( mod med m \)$.

There are two ways to find the modular inverse.

==== Fermat's Little Theorem

For $a in bb(Z)$ and prime $p$, we have $a^p equiv a med \( mod med p \)$. After basic algebraic manipulation, we get $a^(p - 2) equiv a^(- 1) med \( mod med p \)$.

Proof: #link("https://hackmd.io/@Ccucumber12/Hy8nj-fxt#/3/10") .

Implemented using fast exponentiation, this gives an $O \( log p \)$ solution.

==== Extended GCD

$a x + b y = gcd \( a \, b \)$. First find $a x = 1 med \( mod med p \)$, which leads to $a x - 1 = p z$, i.e., $a x - p z = 1$
$arrow.r.double a x + p z = g c d \( a \, p \)$
