#import "../../template.typ": *

== Examples and Practice
=== Number Theory
==== Problem: CF 1553A Digits Sum
*Problem Statement*

Let us define $S \( x \)$ as the sum of the digits of integer $x$ in the decimal system. For example, $S \( 5 \) = 5$, $S \( 10 \) = 1$, $S \( 322 \) = 7$.

We call an integer $x$ "interesting" if $S \( x + 1 \) < S \( x \)$. In each test case, you are given an integer $n$. Your task is to count how many interesting integers $x$ exist in the range $1 lt.eq x lt.eq n$.

*Input*

The first line contains an integer $t$ ($1 lt.eq t lt.eq 1000$) — the number of test cases.

The next $t$ lines each contain an integer $n$ ($1 lt.eq n lt.eq 10^9$), representing the value of $n$ in the $i$-th test case.

*Output*

Output $t$ integers, where the $i$-th integer is the answer to the $i$-th test case.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1`#linebreak()`9`#linebreak()`10`#linebreak()`34`#linebreak()`880055535`], [`0`#linebreak()`1`#linebreak()`1`#linebreak()`3`#linebreak()`88005553`],
)
==== Problem: CF 1542C Strange Function
*Problem Statement*

Let $f \( i \)$ denote the smallest positive integer $x$ such that $x$ is not a divisor of $i$.

Compute $sum_(i = 1)^n f \( i \)$ modulo $10^9 + 7$. In other words, compute $f \( 1 \) + f \( 2 \) + dots.h.c + f \( n \)$ modulo $10^9 + 7$.

*Input*

The first line contains an integer $t$ ($1 lt.eq t lt.eq 10^4$), the number of test cases.

The next $t$ lines each contain a single integer $n$ ($1 lt.eq n lt.eq 10^16$).

*Output*

For each test case, output a single integer $a n s$, where $a n s = sum_(i = 1)^n f \( i \)$ modulo $10^9 + 7$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1`#linebreak()`9`#linebreak()`10`#linebreak()`34`#linebreak()`880055535`], [`0`#linebreak()`1`#linebreak()`1`#linebreak()`3`#linebreak()`88005553`],
)
==== Problem: CF 913A Modular Exponentiation
*Problem Statement*

The following is a well-known problem: given integers $n$ and $m$, compute

$ 2^n med \( mod med m \) $

where $2^n = 2 times 2 times dots.h.c times 2$ ($n$ factors), and `mod` denotes the remainder of division.

Now solve the "reverse" problem. Given integers $n$ and $m$, compute

$ m med \( mod med 2^n \) $

*Input*

The first line contains an integer $n$ ($1 lt.eq n lt.eq 10^8$).

The second line contains an integer $m$ ($1 lt.eq m lt.eq 10^8$).

*Output*

Output a single integer representing the value of $m med \( mod med 2^n \)$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`42`], [`10`],
  [Sample Input 2], [Sample Output 2],
  [`1`#linebreak()`58`], [`0`],
)

Luogu P1082 \[NOIP2012 Advanced Division\] Congruence Equation

*Problem Statement*

Find the minimum positive integer solution for $x$ in the congruence equation $a x equiv 1 med \( mod med b \)$.

*Input*

One line containing two integers $a \, b$ separated by a space.

$2 lt.eq a \, b lt.eq 2 \, 000 \, 000 \, 000$

*Output*

A single integer $x_0$, the minimum positive integer solution. The input is guaranteed to have a solution.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 10`], [`7`],
)
==== Problem: 洛谷P1495 [Template] Chinese Remainder Theorem (CRT) / Cao Chong Raises Pigs
*Problem Statement*

Ever since Cao Chong weighed the elephant, Cao Cao began wondering how to put his son to work. He sent Cao Chong to raise pigs at a farm in the Central Plains. Cao Chong was unhappy about this and worked carelessly. One day Cao Cao wanted to know the number of sows, so Cao Chong decided to mess with him. For example, suppose there are $16$ sows. If you build $3$ pens, $1$ pig has no place to stay. If you build $5$ pens, still $1$ pig has no place to go. If you build $7$ pens, $2$ pigs have no place to go. As Cao Cao's personal secretary, it is your duty to report the exact pig count to him — how do you figure it out?

*Input*

The first line contains an integer $n$ — the number of times pens are built. The next $n$ lines each contain two integers $a_i \, b_i$, meaning $a_i$ pens were built and $b_i$ pigs have no place to go. You may assume $a_1 tilde.op a_n$ are pairwise coprime.

$1 lt.eq n lt.eq 10$，$0 lt.eq b_i < a_i lt.eq 100000$，$1 lt.eq product a_i lt.eq 10^18$

*Output*

Output a single positive integer — the minimum number of sows Cao Chong could be raising.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`3 1`#linebreak()`5 1`#linebreak()`7 2`], [`16`],
)
==== Problem: AtCoder ABC 186E Throne
*Problem Statement*

We have $N$ chairs arranged in a circle, one of which is a throne.

Takahashi initially sits in a chair that is $S$ chairs away from the throne in the clockwise direction. He repeatedly performs the following move.

Move: Move clockwise to the chair $K$ positions ahead of his current chair.

After how many moves will he first sit on the throne? If he never sits on it, report $- 1$.

You need to solve $T$ test cases.

*Input*

Input is given in the following format. The first line is:

$T$

Then the following $T$ lines represent $T$ test cases. Each line is:

$N #h(0em) S #h(0em) K$

$1 lt.eq T lt.eq 100$，$2 lt.eq N lt.eq 10^9$，
$1 lt.eq S < N$，$1 lt.eq K lt.eq 10^9$

*Output*

Output a single positive integer — the number of moves until Takahashi first sits on the throne.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`10 4 3`#linebreak()`1000 11 2`#linebreak()`998244353 897581057 595591169`#linebreak()`10000 6 14`], [`2`#linebreak()`-1`#linebreak()`249561088`#linebreak()`3571`],
)
==== Problem: ZJ d308 Chocolate Adventure Factory
*Problem Statement*

Zhe-Wei, as president of CRC, is in big trouble...

Because of an upcoming informatics camp, he spared no expense and ordered chocolates from the world's largest chocolate factory — Wonka Industries — to distribute to the participating students.

Zhe-Wei has learned through special channels that $m$ team members will attend the camp. In the spirit of fairness, he wants to distribute the chocolates equally among the team members.

But here's the problem: it's very likely that the chocolates cannot be divided evenly among the team members, meaning there will be leftovers. As fate would have it, the factory owner Willy Wonka has a peculiar obsession.

He ordered Zhe-Wei not to have any leftover chocolates, and not to return the extras either — otherwise Willy Wonka would have the Oompa Loompas throw Zhe-Wei into the chocolate river.

Caught between a rock and a hard place...........................................

Zhe-Wei decided to eat all the leftover chocolates himself~(￣▽￣)~(＿△＿)~(￣▽￣)~(＿△＿)~(￣▽￣)~

Can you help calculate exactly how many chocolates Zhe-Wei has to eat, so he can mentally prepare?

*Input*

Two positive integers n and m, representing n chocolates and m team members.

We guarantee:

$n < 10^1000000$，$m < 1000000$

*Output*

A single integer representing the number of chocolates Zhe-Wei must eat.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`9999 1188`], [`495`],
)

=== Combinatorics
==== Problem: CF 610A Pasha and Stick
*Problem Statement*

Pasha has a stick whose length is a positive integer $n$. He wants to make three cuts, dividing the stick into four parts. Each part must have a positive integer length, and the lengths must sum to $n$.

Pasha likes rectangles but dislikes squares, so he wants to know how many ways he can cut the stick into four parts such that the parts can form a rectangle but not a square.

Your task is to help Pasha count the number of such cuts. Two cuts are considered different if there exists some integer $x$ such that the number of parts with length $x$ differs between the two cuts.

*Input*

The first line of input contains a positive integer $n$ ($1 lt.eq n lt.eq 2 times 10^9$), the length of Pasha's stick.

*Output*

Output a single integer representing the number of ways to cut Pasha's stick into four parts such that the parts can form a rectangle (by connecting the endpoints) but not a square.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6`], [`1`],
  [Sample Input 2], [Sample Output 2],
  [`20`], [`4`],
)
==== Problem: CF 52B Right Triangles
*Problem Statement*

Given an $n times m$ grid containing only dots ('.') and asterisks ('\*'), count the number of right triangles whose vertices are all at the centers of asterisk ('\*') cells and whose two legs are parallel to the sides of the grid. A right triangle is a triangle with one 90-degree angle.

*Input*

The first line contains two positive integers $n$ and $m \( 1 lt.eq n \, m lt.eq 1000 \)$. The next $n$ lines each contain $m$ characters describing the grid layout. Only '.' and '\*' will appear.

*Output*

Output a single integer representing the total number of right triangles in the grid. Do not use the `%lld` format specifier in C++ to read or write 64-bit integers. It is recommended to use cout (or `%I64d`).

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`2 2`#linebreak()`**`#linebreak()`*.`], [`1`],
  [Sample Input 2], [Sample Output 2],
  [`3 4`#linebreak()`*..*`#linebreak()`.**.`#linebreak()`*.**`], [`9`],
)
