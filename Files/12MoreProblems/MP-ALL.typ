This chapter mainly translates some English problems for your practice.
Note that I may not be able to solve all of them either.

== Practice Problems
==== Problem: AtCoder ABC 126D Even Relation
*Problem Statement*

We have a tree with N vertices numbered $1$ to $N$. The $i$-th edge connects vertex $u_i$ and vertex $v_i$, and has length $w_i$. Your goal is to paint each vertex of the tree white or black (painting all vertices the same color is also allowed), such that the following condition is satisfied:

For any two vertices painted the same color, the distance between them is an even number.

Find a valid coloring and output it. It can be proven that at least one valid coloring exists under the constraints of this problem.

*Input Description*

Input is given from standard input in the following format:

$N$

$u_1 v_1 w_1$

$u_2 v_2 w_2$

$dots.v$

$u_(N - 1) v_(N - 1) w_(N - 1)$

All values in the input are integers. $1 lt.eq N lt.eq 10^5$

$1 lt.eq u_i lt.eq v_i lt.eq N$

$1 lt.eq w_i lt.eq 10^9$

*Output Description*

Output the coloring in $N$ lines. The $i$-th line should contain $0$ if vertex $i$ is painted white, and $1$ if vertex $i$ is painted black.

If multiple valid colorings exist, any one of them is accepted.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`1 2 2`#linebreak()`2 3 1`], [`0`#linebreak()`0`#linebreak()`1`],
)

==== Problem: AtCoder ABC 127D Integer Cards
*Problem Statement*

You have $N$ cards. The $i$-th card has the integer $A_i$ written on it.

In order, for each $j = 1 \, 2 \, dots.h.c \, M$, you perform the following operation once:

Operation: Choose at most $B_j$ cards (possibly zero). Replace the integer written on each chosen card with $C_j$.

Find the maximum possible sum of integers on the cards after $M$ operations.

*Input Description*

Input is given from standard input in the following format:

$N$

$M$

$A_1 A_2 dots.h.c A_N$

$B_1 C_1$

$B_2 C_2$

$dots.v$

$B_M C_M$

All values in the input are integers.

$1 lt.eq N lt.eq 10^5$

$1 lt.eq M lt.eq 10^5$

$1 lt.eq A_i \, C_i lt.eq 10^9$

$1 lt.eq B_i lt.eq N$

*Output Description*

Output the maximum possible sum of integers on the cards after $M$ operations.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 2`#linebreak()`5 1 4`#linebreak()`2 3`#linebreak()`1 5`], [`14`],
)

==== Problem: AtCoder ABC 128E Integer Cards
*Problem Statement*

There is an infinitely long street extending from west to east, which we treat as a number line.

$N$ road construction projects are scheduled on this street. The $i$-th project will block the point at coordinate $X_i$ from time $S_i - 0.5$ to time $T_i - 0.5$.

$Q$ people are standing at coordinate $0$. The $i$-th person starts at coordinate $0$ at time $D_i$, walks in the positive direction at speed $1$, and stops when they reach a blocked point.

Find the distance each of the $Q$ people will walk.

*Input Description*

Input is given from standard input in the following format:

$N$

$Q$

$S_1 quad T_1 quad X_1$

$quad quad dots.v$

$S_N quad T_N quad X_N$

$D_1$

$dots.v$

$D_Q$

All values in the input are integers.

$1 lt.eq N \, Q lt.eq 2 times 10^5$

$0 lt.eq S_i lt.eq T_i lt.eq 10^9$

$1 lt.eq X_i lt.eq 10^9$

$0 lt.eq D_1 < D_2 < dots.h.c < D_Q lt.eq 10^9$

If $i eq.not j$ and $X_i = X_j$, then the intervals $\[ S_i \, T_i \)$ and
$\[ S_j \, T_j \)$ do not overlap.

*Output Description*

Output $Q$ lines. The $i$-th line should contain the distance the $i$-th person will walk, or $- 1$ if that person walks indefinitely.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: AtCoder ABC 140D Face Produces Unhappiness
*Problem Statement*

There are $N$ people standing in a line from west to east.

You are given a string $S$ of length $N$ describing the direction each person faces. If the $i$-th character of $S$ is L, the $i$-th person from the west faces west; if the $i$-th character is R, that person faces east.

A person is happy if the person directly in front of them faces the same direction. However, if no one is in front of a person, they are unhappy.

You may perform the following operation between $0$ and $K$ times (inclusive):

Operation: Choose integers $l$ and $r$ satisfying
$1 lt.eq l lt.eq r lt.eq N$, and rotate the segment of the line from person $l$ to person $r$ by $180$ degrees. That is, for each
$i = 0 \, 1 \, dots.h.c \, r - l$, after the operation, person $l + i$ stands at the position of person $r - i$ and faces the opposite direction.

What is the maximum number of people you can make happy?

*Input Description*

Input is given from standard input in the following format:

$N$

$K$

$S$

$N$ is an integer satisfying $1 lt.eq N lt.eq 10^5$.

$K$ is an integer satisfying $1 lt.eq K lt.eq 10^5$.

The string $S$ has length $N$.

Each character of $S$ is L or R.

*Output Description*

Output the maximum number of happy people after at most $K$ operations.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 4`#linebreak()`1 9 3 5`], [`6`],
)

==== Problem: AtCoder ABC 141D Powerful Discount Tickets
*Problem Statement*

Takahashi plans to buy $N$ items one by one.

The price of the $i$-th item is $A_i$ yen (Japanese currency).

He has $M$ discount tickets, and he can use any number of them when buying an item.

If he uses $Y$ tickets when buying an item priced at $X$ yen, he can purchase it for
$floor.l frac(2 Y, X) floor.r$
yen (rounded down to the nearest integer).

Find the minimum total amount needed to buy all items.

*Input Description*

Input is given from standard input in the following format:

$N$

$M$

$A_1$

$A_2$

$dots.v$

$A_N$

All values in the input are integers.

$1 lt.eq N \, M lt.eq 10^5$

$1 lt.eq A_i lt.eq 10^9$

*Output Description*

Output the minimum total amount needed to buy all items.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 3`#linebreak()`2 13 8`], [`9`],
)

==== Problem: AtCoder ABC 142E Get Everything
*Problem Statement*

We have $N$ locked treasure chests numbered $1$ to $N$.

A store sells $M$ keys. The $i$-th key costs $a_i$
yen (Japanese currency) and can open $b_i$ chests: chests $c_(i 1)$,
$c_(i 2)$, $dots.h.c$, $c_(i b_i)$.

Each purchased key can be used any number of times.

Find the minimum cost to open all chests. If it is impossible to open all chests, output $- 1$.

*Input Description*

Input is given from standard input in the following format:

$N quad M$

$a_1 quad b_1 quad c_11 quad c_12 quad dots.h.c quad c_(1 b_1)$

$dots.v$

$a_M quad b_M quad c_(M 1) quad c_(M 2) quad dots.h.c quad c_(M b_M)$

All values in the input are integers.

$1 lt.eq N lt.eq 12$

$1 lt.eq M lt.eq 10^3$

$1 lt.eq a_i lt.eq 10^5$

$1 lt.eq b_i lt.eq N$

$1 lt.eq c_(i 1) < c_(i 2) < dots.h.c < c_(i b_i) lt.eq N$

*Output Description*

Output the minimum cost to open all chests. If it is impossible to open all chests, output $- 1$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: AtCoder ABC 143D Triangles
*Problem Statement*

Takahashi has $N$ distinguishable sticks. The $i$-th stick has length $L_i$.

He wants to form a triangle using these sticks. Let $a$, $b$, and $c$ be the lengths of the three sticks used. The following conditions must all be satisfied:

$a < b + c$

$b < c + a$

$c < a + b$

How many different triangles can be formed? Two triangles are considered different if there is a stick used in one but not the other.

*Input Description*

Input is given from standard input in the following format:

$N$

$L_1 med L_2 med . . . med L_N$

$3 lt.eq N lt.eq 2 times 10^3$

$1 lt.eq L_i lt.eq 10^3$

*Output Description*

Output the number of different triangles that can be formed.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`3 4 2 1`], [`1`],
)

==== Problem: AtCoder ABC 144E Gluttony
*Problem Statement*

Takahashi will participate in an eating contest. The contest has N teams competing, and Takahashi's team consists of N members numbered 1 to N from youngest to oldest. Member $i$ has an endurance coefficient of $A_i$.

The contest provides N food items numbered 1 to N, each with difficulty $F_i$. The contest details are as follows:

A team should assign one member to each food item, and the same member should not be assigned to multiple food items.
The time a member takes to finish a food item is $x times y$ seconds, where $x$ is the member's endurance coefficient and $y$ is the food's difficulty.
The team's score is the longest time any individual member takes to finish their food.
Before the contest, Takahashi's team decides to do some training. In one training session, a member can reduce his/her endurance coefficient by 1, as long as it does not go below 0. However, for financial reasons, the N members combined can train at most K times in total.

Given that the team chooses the amount of training for each member and assigns food items optimally, what is the minimum possible team score?

*Input Description*

Input is given from standard input in the following format:

$N med K$

$A_1 med A_2 med dots.h.c med A_N$

$F_1 med F_2 med dots.h.c med F_N$

All input values are integers.

$1 lt.eq N lt.eq 2 times 10^5$

$0 lt.eq K lt.eq 10^18$

$1 lt.eq A_i lt.eq 10^6 \( 1 lt.eq i lt.eq N \)$

$1 lt.eq F_i lt.eq 10^6 \( 1 lt.eq i lt.eq N \)$

*Output Description*

Output the minimum possible team score.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 5`#linebreak()`4 2 1`#linebreak()`2 3 1`], [`2`],
)

==== Problem: AtCoder ABC 145F Laminate
*Problem Statement*

We will create an artwork by painting some cells black in a white square grid with
$10^9$ rows and $N$ columns. The current plan is: for the $i$-th column from the left,
we paint the bottom $H_i$ cells black and leave the rest white.
Before starting work, you may choose at most $K$ columns (or none at all) and change
their $H_i$ values to any integer in the range $0$ to $10^9$ (inclusive).
Different columns may be assigned different $H_i$ values.
Then, you repeatedly perform the following operation to create the modified artwork:

Choose one or more consecutive cells in a row and paint them black. (Already-black cells may be painted again, but according to the modified plan, you should not paint cells that do not need to be black.)
Find the minimum number of operations required.

*Input Description*

Input is given from standard input in the following format:

$N$

$K$

$H_1 quad H_2 quad dots.h.c quad H_N$

All input values are integers.

$1 lt.eq N lt.eq 300$

$0 lt.eq K lt.eq N$

$0 lt.eq H_i lt.eq 10^9$

*Output Description*

Output the minimum number of operations required.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 1`#linebreak()`2 3 4 1`], [`3`],
)

==== Problem: CF 1840D Wooden Toy Festival
*Problem Statement*

In a small town, there is a workshop specializing in woodworking. Since the town is small, only three woodcarvers work there.

Soon the town plans to hold a wooden toy festival. The workshop staff hope to prepare for it.

They know that $n$
people will come to the workshop with requests to make wooden toys. Each person is different and may want a different toy. For simplicity, we represent the toy style that the $i$-th person wants as $a_i$ ($1 lt.eq i lt.eq 10^9$).

Each woodcarver can choose in advance an integer style $x$
($1 lt.eq x lt.eq 10^9$); different woodcarvers may choose different styles. $x$
is an integer. In preparing for the festival, the woodcarver will perfectly practice making the chosen style of toy, allowing him to carve it from wood immediately. For a woodcarver who has chosen style
$x$, making a toy of style $y$ will take $\| x - y \|$
time, since the more similar a toy is to the one he can make immediately, the faster the woodcarver finishes.

On the day of the festival, when the next person comes to the workshop with a request to make a wooden toy, the woodcarvers can choose who takes the job. The woodcarvers are all highly skilled and can work for different people simultaneously.

Since people dislike waiting, the woodcarvers want to choose their prepared styles to minimize the maximum waiting time among all people.

Output the optimal maximum waiting time the woodcarvers can achieve.

*Input Description*

The first line of input contains an integer $t$ ($1 lt.eq t lt.eq 10^4$) ---
the number of test cases.

Then come the descriptions of the test cases.

The first line of each test case contains an integer $n$ ($1 lt.eq n lt.eq 2 times 10^5$)
--- the number of people coming to the workshop.

The second line of each test case contains $n$ integers $a_1 \, a_2 \, a_3 \, dots.h \, a_n$
($1 lt.eq a_i lt.eq 10^9$) --- the toy styles.

The sum of all $n$ values across all test cases does not exceed $2 times 10^5$.

*Output Description*

Output $t$ numbers, each being the answer to the corresponding test case ---
the optimal maximum waiting time the woodcarvers can achieve.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1830A Copil Copac Draws Trees
*Problem Statement*

Copil
Copac is given a tree of $n$ vertices described by $n - 1$ edges. He decides to draw the tree using the following algorithm:

Step 0: Draw the first vertex (vertex 1). Go to Step 1.

Step 1: For each edge in the input, in order, perform the following: if the edge connects an already-drawn vertex $u$ and an undrawn vertex $v$, draw vertex $v$ and that edge. After checking all edges, go to Step 2.

Step 2: If all vertices have been drawn, end the algorithm. Otherwise, return to Step 1.

The number of reads is defined as the number of times Copil Copac executes Step 1.

Find the number of reads required for Copil Copac to draw the tree.

*Input Description*

Each test contains multiple test cases. The first line contains an integer $t$
$\( 1 lt.eq t lt.eq 10^4 \)$, the number of test cases. Then come the descriptions of each test case.

The first line of each test case contains an integer $n$
$\( 2 lt.eq n lt.eq 2 times 10^5 \)$, the number of vertices in the tree.

The following $n - 1$ lines each contain two integers $u_i$ and $v_i$
$\( 1 lt.eq u_i \, v_i lt.eq n \, u_i eq.not v_i \)$, denoting the endpoints of the $i$-th edge $\( u_i \, v_i \)$. The given edges are guaranteed to form a tree.

The sum of $n$ across all test cases is guaranteed not to exceed $2 times 10^5$.

*Output Description*

For each test case, output the number of reads required for Copil Copac to draw the tree.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1824A LuoTianyi and the Show
*Problem Statement*

There are $n$ people attending a VOCALOID concert. They will sit in seats numbered $1$ to $m$ from left to right, one by one in order.

Each person can occupy a seat in one of three ways:

Sit to the left of the leftmost occupied seat; if seat 1 is already occupied, leave the concert. If no one is seated yet, sit in seat $m$.

Sit to the right of the rightmost occupied seat; if seat $m$ is already occupied, leave the concert. If no one is seated yet, sit in seat 1.

Sit in seat number $x_i$. If that seat is already occupied, leave the concert.

Now you want to know: if you can arrange the order in which people enter the concert, what is the maximum number of people who can occupy seats?

*Input Description*

Each test contains multiple test cases. The first line contains an integer $t$
$\( 1 lt.eq t lt.eq 10^4 \)$, the number of test cases. Then come the descriptions of each test case.

The first line of each test case contains two integers $n$ and $m$
$\( 1 lt.eq n \, m lt.eq 10^5 \)$, the number of people and the number of seats.

The second line of each test case contains $n$ integers $x_1 \, x_2 \, dots.h \, x_n$
$\( - 2 lt.eq x_i lt.eq m \, x_i eq.not 0 \)$, where the $i$-th integer describes how the $i$-th person occupies a seat:

If $x_i = - 1$, the $i$-th person occupies a seat using the first method.

If $x_i = - 2$, the $i$-th person occupies a seat using the second method.

If $x_i > 0$, the $i$-th person occupies a seat using the third method: they want to sit in seat $x_i$, and leave the concert if that seat is already taken.

The sum of $n$ and the sum of $m$ across all test cases are each guaranteed not to exceed $10^5$.

*Output Description*

For each test case, output one integer representing the maximum number of people who can occupy seats.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1826D Running Miles
*Problem Statement*

There are $n$ attractions on a street, where the $i$-th attraction is $i$ miles from the start of the street. The beauty of the $i$-th attraction is $b_i$. You want to start jogging from $l$ miles from the start and end at $r$ miles from the start. During your jog, you pass all attractions in your route (including those at exactly $l$ and $r$ miles). You are interested in the three most beautiful attractions along your route, but as the miles you run increase, you get more and more tired.

Therefore, choose $l$ and $r$ such that you pass at least three attractions, and the sum of the beauties of the three most beautiful attractions minus the number of miles you need to run is maximized. More formally, choose $l$ and $r$ to maximize $b_(i 1) + b_(i 2) + b_(i 3) - \( r - l \)$, where $i_1$, $i_2$, $i_3$ are the indices of the three largest elements in the interval $\[ l \, r \]$.

*Input Description*

The first line contains an integer $t$ $\( 1 lt.eq t lt.eq 10^5 \)$, the number of test cases.

The first line of each test case contains an integer $n$
$\( 3 lt.eq n lt.eq 10^5 \)$, the number of attractions on the street.

The second line of each test case contains $n$ integers $b_i$
$\( 1 lt.eq b_i lt.eq 10^8 \)$, the beauty of the attraction $i$ miles from the start.

The sum of all $n$ values is guaranteed not to exceed $10^5$.

*Output Description*

For each test case, output one integer representing the maximum value of $b_(i 1) + b_(i 2) + b_(i 3) - \( r - l \)$ over some jogging interval $\[ l \, r \]$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1779D Boris and His Amazing Haircut
*Problem Statement*

Boris thinks chess is a boring game, so he left the match early and went to a barbershop because his hair was a bit messy.

His current hair can be described by an array $a_1 \, a_2 \, dots.h \, a_n$, where $a_i$ represents the hair height at position $i$. His desired hairstyle is similarly described by an array $b_1 \, b_2 \, dots.h \, b_n$.

The barber has $m$ clippers, each with its own size, and each can be used at most once. In one operation, the barber chooses an unused clipper of size $x$, then chooses an interval $\[ l \, r \]$ ($1 lt.eq l lt.eq r lt.eq n$) and cuts the hair in that interval. More formally, one operation consists of the following:

Choose any unused clipper of size $x$;

Choose an interval $\[ l \, r \]$;

For each $i$ satisfying $l lt.eq i lt.eq r$, set $a_i = min \( a_i \, x \)$;

Note that some clippers may have the same size, and the barber can use a clipper of a particular size at most as many times as there are clippers of that size.

The barber may perform as many operations as needed, as long as each clipper is used at most once and the final result satisfies $a_i = b_i$ for every $1 lt.eq i lt.eq n$. It is not necessary to use all clippers.

Can you determine whether the barber can give Boris his desired hairstyle?

*Input Description*

Each test contains multiple test cases. The first line contains an integer $t$
$\( 1 lt.eq t lt.eq 20000 \)$, the number of test cases. Then come the descriptions of each test case.

The first line of each test case contains a positive integer $n$
$\( 3 lt.eq n lt.eq 2 times 10^5 \)$, the length of arrays $a$ and $b$.

The second line of each test case contains $n$ positive integers $a_1 \, a_2 \, dots.h \, a_n$
$\( 1 lt.eq a_i lt.eq 10^9 \)$, representing Boris's current hair.

The third line of each test case contains $n$ positive integers $b_1 \, b_2 \, dots.h \, b_n$
$\( 1 lt.eq b_i lt.eq 10^9 \)$, representing Boris's desired hairstyle.

The fourth line of each test case contains a positive integer $m$
$\( 1 lt.eq m lt.eq 2 times 10^5 \)$, the number of clippers.

The fifth line of each test case contains $m$ positive integers $x_1 \, x_2 \, dots.h \, x_m$
$\( 1 lt.eq x_i lt.eq 10^9 \)$, the sizes of the clippers.

The sum of $n$ and $m$ across all test cases is guaranteed not to exceed $2 times 10^5$.

*Output Description*

For each test case, output "YES" if the barber can give Boris his desired hairstyle; otherwise output "NO".

You may use any capitalization (upper or lower case). For example, "yEs", "yes", "Yes", and "YES" will all be accepted as a positive answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1731D Valiant's New Map
*Problem Statement*

The game company "DbZ Games" wants to add a new map to their popular game "Valiant".
This time, the map named "Panvel" will be based on the city of Mumbai.

Mumbai can be represented as an $n times m$ grid of cells. Each cell $\( i \, j \)$
($1 lt.eq i lt.eq n$; $1 lt.eq j lt.eq m$) is occupied by a rectangular building of height $a_(i \, j)$.

This time, DbZ Games
wants to create a map with perfect vertical gameplay. Therefore, they want to choose an
$l times l$ square such that every building inside the square has height at least $l$.

Can you help DbZ Games find the maximum possible side length $l$ of such a square?

*Input Description*

Each test contains multiple test cases. The first line contains an integer $t$
($1 lt.eq t lt.eq 1000$), the number of test cases. Then come the descriptions of each test case.

The first line of each test case contains two positive integers $n$ and $m$
($1 lt.eq n lt.eq m$; $1 lt.eq n times m lt.eq 10^6$).

The $i$-th of the following $n$ lines contains $m$ integers
$a_(i \, 1) \, a_(i \, 2) \, dots.h \, a_(i \, m)$
($1 lt.eq a_(i \, j) lt.eq 10^6$), representing the building heights in row $i$.

The sum of $n times m$ across all test cases is guaranteed not to exceed $10^6$.

*Output Description*

For each test case, output the maximum side length $l$ of the square that DbZ Games can choose.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1841D Pairs of Segments
*Problem Statement*

Two intervals $\[ l_1 \, r_1 \]$ and $\[ l_2 \, r_2 \]$ intersect if there exists at least one
$x$ satisfying $l_1 lt.eq x lt.eq r_1$ and $l_2 lt.eq x lt.eq r_2$.

An array of intervals
$\[ \[ l_1 \, r_1 \] \, \[ l_2 \, r_2 \] \, dots.h \, \[ l_k \, r_k \] \]$
is called beautiful if $k$ is even and the elements of the array can be partitioned into $k / 2$
pairs satisfying the following conditions:

Each element belongs to exactly one pair.

The intervals in each pair intersect each other.

Intervals from different pairs do not intersect.

For example, the array
$\[ \[ 2 \, 4 \] \, \[ 9 \, 12 \] \, \[ 2 \, 4 \] \, \[ 7 \, 7 \] \, \[ 10 \, 13 \] \, \[ 6 \, 8 \] \]$
is beautiful because it can be partitioned into 3 pairs as follows:

The first element (interval $\[ 2 \, 4 \]$) and the third element (interval $\[ 2 \, 4 \]$).

The second element (interval $\[ 9 \, 12 \]$) and the fifth element (interval
$\[ 10 \, 13 \]$).

The fourth element (interval $\[ 7 \, 7 \]$) and the sixth element (interval $\[ 6 \, 8 \]$).

As you can see, the intervals in each pair intersect, and intervals from different pairs do not intersect.

Given an array of $n$ intervals
$\[ \[ l_1 \, r_1 \] \, \[ l_2 \, r_2 \] \, dots.h \, \[ l_n \, r_n \] \]$,
find the minimum number of elements to remove so that the resulting array is beautiful.

*Input Description*

The first line contains an integer $t$($1 lt.eq t lt.eq 1000$), the number of test cases.

The first line of each test case contains an integer
$n$($2 lt.eq n lt.eq 2000$), the number of intervals in the array.

The following $n$ lines each contain two integers $l_i$ and
$r_i$($0 lt.eq l_i lt.eq r_i lt.eq 10^9$), representing the $i$-th interval.

Additional constraint: the sum of $n$ across all test cases does not exceed $2000$.

*Output Description*

For each test case, output one integer representing the minimum number of elements you need to remove so that the resulting array is beautiful.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1582E Pchelyonok and Segments
*Problem Statement*

Pchelyonok has decided to give Mila a gift. He has already bought an array $a$ of length
$n$, but giving an array as a gift is too ordinary. Instead, he decided to give Mila segments of the array!

Pchelyonok wants his gift to be special, so he plans to choose $k$
non-overlapping intervals
$\[ l_1 \, r_1 \] \, \[ l_2 \, r_2 \] \, dots.h \, \[ l_k \, r_k \]$ from the array satisfying the following conditions:

The first interval $\[ l_1 \, r_1 \]$ has length $k$, the second interval
$\[ l_2 \, r_2 \]$ has length $k - 1$, and so on, with the last interval
$\[ l_k \, r_k \]$ having length $1$.

For all $i < j$, the $i$-th interval comes before the $j$-th interval (i.e., $r_i < l_j$).

The sums of the intervals must be strictly increasing (i.e., for each interval $\[ l \, r \]$, let
$sum_(i = l)^r a_i$ denote the sum of all elements in that interval; then
$sum_(i = l_1)^(r_1) a_i < sum_(i = l_2)^(r_2) a_i < dots.h < sum_(i = l_k)^(r_k) a_i$).

Pchelyonok wants his gift to be as special as possible, so he asks you to find the maximum value of $k$
so that he can give Mila a special gift!

*Input Description*

The first line contains an integer $t$($1 lt.eq t lt.eq 100$), the number of test cases.

The following $2 t$ lines contain the descriptions of the test cases. Each test case description consists of two lines.

The first line of each test case contains an integer
$n$($1 lt.eq n lt.eq 10^5$), the length of the array.

The second line contains $n$ integers
$a_1 \, a_2 \, dots.h \, a_n$($1 lt.eq a_i lt.eq 10^9$), the elements of array $a$.

The sum of $n$ across all test cases is guaranteed not to exceed $10^5$.

*Output Description*

For each test case, output the maximum possible value of $k$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

==== Problem: CF 1613E Crazy Robot
*Problem Statement*

There is a grid with $n$ rows and $m$ columns. Each cell of the grid is either empty or blocked. There is a laboratory in one of the empty cells. All cells outside the grid boundary are blocked.

A crazy robot has escaped from the laboratory. It is currently in some empty cell of the grid. You can send the robot one of the following commands: "move right", "move down", "move left", or "move up". Each command means moving to the adjacent cell in the corresponding direction.

However, since the robot is crazy, it will do anything except follow commands. Upon receiving a command, it will choose a direction different from the commanded direction such that the cell in that direction is not blocked. If such a direction exists, it moves to the adjacent cell in that direction. Otherwise, it does nothing.

We want to send the robot to the laboratory for repair. For each empty cell, determine whether it is possible to force the robot to reach the laboratory starting from that cell. That is, after each move the robot makes, you can send it a command such that no matter which different direction the robot chooses, it will eventually reach the laboratory.

*Input Description*

The first line contains an integer $t$($1 lt.eq t lt.eq 1000$), the number of test cases.

The first line of each test case contains two integers $n$ and $m$($1 lt.eq n \, m lt.eq 10^6$; $n times m lt.eq 10^6$), the number of rows and columns in the grid.

The following $n$ lines each describe one row of the grid. Each row consists of $m$ elements, which can be one of three types:

'.' --- the cell is empty;

`#` --- the cell is blocked;

'L' --- the cell contains the laboratory.

The sum of $n times m$ across all test cases does not exceed $10^6$.

*Output Description*

For each test case, find all empty cells from which the robot can be forced to reach the laboratory. In the given grid, replace each empty cell (represented by a dot) with a plus sign ('+') if the robot can be forced to reach the laboratory from that cell. Output the modified grid.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)
