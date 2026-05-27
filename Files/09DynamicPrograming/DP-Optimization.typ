== DP Optimization
=== Introduction
In this section I will mention some optimization techniques. However, since there are many optimizations I am not familiar with, what I can offer is limited.

=== Rolling Array
In the previous section we discussed the knapsack problem, where the space complexity was
$O \( n W \)$. In some contests, this much memory may not be allowed.
In that case, we can examine the recurrence and notice that in the knapsack problem
we only ever use the current row $i$, so we only need two rows of the array.

In practice, we can achieve this with bitwise operations. Of course, `%` also works, but bitwise operations look cooler and have a slightly smaller constant.

==== Solution Code: 0/1 Knapsack

```
ll dp[2][100010],v[105],w[105];

int main(){
    // input
    for(int i=1;i<=n;i++){
        for(int j=1;j<=W;j++){
            if(w[i]>j){
                dp[i&1][j]=dp[i&1^1][j];
            }else{
                dp[i&1][j]=max(dp[i&1^1][j],dp[i&1^1][j-w[i]]+v[i]);
            }
        }
    }
    cout<<dp[n&1][W];
}
```

=== Bitmask DP
Let's look at the following problem.

==== Example: TIOJ 1014 Whack-a-Mole
*Problem Statement*

As time marches on, the whack-a-mole game keeps evolving. The latest generation not only tests your reaction speed but also your stamina and intelligence. The mole base is a long platform with mole holes every meter, numbered $1$ to
$n$ from left to right. The player stands at the far left of the base, $1$ meter away from the first mole hole,
holding a hammer, ready to start the game. The mole in hole $i$ appears every $T_i$
seconds. A mole that has been hit will not appear again; the game ends when all moles have been hit,
and the time from start to end is recorded — the faster the better. The game manufacturer
wants to know the minimum number of seconds needed to end the game, and asks you to write a program to find it.

Assume players have unlimited stamina, always move at 1 meter per second, are unaffected by direction changes, and the time to hit a mole is negligible.

*Input Format*

The first line contains a number $n \, n lt.eq 16$, representing the number of mole holes. The second line contains
$n$ numbers. All numbers are no greater than $10^8$.

*Output Format*

Output the minimum number of seconds $S$ to end the game.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`3 2 5`], [`5`],
)

==== Idea

This is actually a different type of DP, so I will explain it starting from the state definition.
You should have noticed that $n$ is very small, and TIOJ generally does not have weak test data ranges. So
from experience, we know this is a problem with complexity between $O \( 2^n \)$ and $O \( n ! \)$.

First, consider when $n$ is small, e.g. $n = 3$; we would need to define the state as follows:

$ d p \[ m \] \[ i_1 \] \[ i_2 \] \[ i_3 \] \, i_1 \, i_2 \, i_3 in { 0 \, 1 } := "minimum time to finish and stop at position" m $

where $i_1 \, i_2 \, i_3$ indicate whether moles 1, 2, 3 have been hit ($0$ = not hit, $1$ = hit).

However, the problem we ultimately need to solve has up to 16 moles, and we would not want to use a 17-dimensional array.
So we can compress the array indices into a single variable. This technique is not only used in DP, though we are covering it a bit late (it might be moved to Chapter 3 in the future).

How does this actually work? We know that $i_1 \, i_2 \, dots.h.c \, i_n$ each take values of only 0 or 1.
So why not use an `int` to store them? An `int` has 32 bits, and each bit can store a 0 or 1.

$ d p \[ m \] \[ a \] := "compress all" i_k "into state" a $
Besides this, we also need to implement a function GetWaitTime,
which tells us how long it takes to transition from state $a$ to state $b$.

What about the transition? We can come from any point other than $m$.

$ {d p \[ 0 \] \[ 0 \] = 1\
d p \[ m \] \[ a \] = min \( d p \[ k \] \[ a - 2^m \] + G e t W a i t T i m e \( a \, a - 2^m \, d p \[ k \] \[ a - 2^m \] \) \)\
1 lt.eq k lt.eq n \, #h(0em) "transitioning from" k "to" m $

==== Implementation

==== Solution Code: TIOJ 1014

```
#define int ll
using ll=long long;
const ll INF=0x3f3f3f3f3f3f3f3f;

// In practice, 1<<16 is sufficient
int a[20],dp[20][1<<19];

int GetWaitTime(int to,int from,int timeNow){
    int ret=abs(from-to);//time to walk to there
    timeNow+=ret;//time now when walk to target

    //if timeNow=10, a[to]=3 then player should wait 2sec
    if(timeNow%a[to]!=0)
        ret+=a[to]-(timeNow%a[to]);

    return ret;
}

int32_t main(){
    ios::sync_with_stdio(0);cin.tie(0);

    int n;
    cin>>n;

    for(int i=0;i<n;++i){
        cin>>a[i];
    }

    for(int i=0;i<20;++i){
        fill(dp[i],dp[i]+(1<<19),INF);
    }

    dp[0][0]=1;

    // Use bitwise operations to express this process; reviewing bitwise operations is recommended.
    for(int i=1;i<(1<<n);++i){
        for(int j=0;j<n;++j){
            if(!(i&(1<<j))) continue;
            for(int k=0;k<n;++k){
                dp[j][i]=min(
                    dp[j][i],
                    dp[k][i-(1<<j)]+GetWaitTime(j,k,dp[k][i-(1<<j)])
                );
            }
        }
    }

    int ans=INF;

    for(int i=0;i<n;++i){
        ans=min(ans,dp[i][(1<<n)-1]);
    }

    cout<<ans;
}
```

=== Data Structure Optimization
As the name suggests, this uses data structures to speed up the transition.
It is typically used when the transition complexity is $O \( n \)$ or higher, employing structures such as BIT or segment trees.

==== Example: 2022 YiZhong Intra-School Contest F — Fluctuating Wheat Ears
*Problem Statement*

Legend has it that Socrates once led several disciples to the edge of a wheat field and asked them to pick the tallest and best wheat ear. However, they had to walk in a straight line without looking back, and each had only one chance to pick. This story gradually evolved into the optimal stopping problem in mathematics, and the best solution was found — the $37\%$ rule. That is, remember the best wheat ear among the first $37\%$, then pick the first ear encountered in the remaining $63\%$ that is better.

One night, Xiao Chen dreamed of Socrates. Having been emotionally distressed by the ups and downs of the stock market lately, Xiao Chen could not help but complain to Socrates. To encourage Xiao Chen to keep moving forward, Socrates told another wheat ear story. Unlike the previous version, this time Socrates wanted Xiao Chen to look for some wheat ears with fluctuating heights, just like the highs and lows of stock prices. Socrates said:

"Xiao Chen, look at these $N$ wheat ears in front of you; each has a different height $h_i$ and value
$v_i$.
Why not find some wheat ears such that their heights in order are fluctuating and the total value is maximized?
I believe this will surely benefit your life!"

More precisely, if $h_1 \, h_2 \, dots.h.c \, h_k$
are the heights of the chosen wheat ears in order, they must satisfy the fluctuation condition:
$ (h_(j - 1) < h_j > h_(j + 1)) or (h_(j - 1) > h_j < h_(j + 1)) \, quad forall j in \[ 2 \, k - 1 \] $
That is, when the chosen wheat ears are laid out in a row, their heights form a zigzag pattern alternating high and low.

After waking up, Xiao Chen urgently examined the data for these $N$ wheat ears, trying to find the optimal choice.
However, there were too many wheat ears, and Xiao Chen could not properly verify all possibilities.
Please help Xiao Chen find the maximum total value under the optimal choice, to make their life a little less miserable.

*Input Format*

The first line contains a positive integer $N$, representing the number of wheat ears.

The following $N$ lines each contain two integers $h_i \, v_i$, representing the height and value of the $i$-th wheat ear.

Variable constraints:

- $1 lt.eq N lt.eq 2 times 10^5$

- $- 10^9 lt.eq h_i \, v_i lt.eq 10^9$

*Output Format*

Output a single integer representing the maximum possible total value.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [], [],
)

#figure(image("../Images/DP4.jpg", width: 80.0%),
  caption: none
)

==== Idea

If you have learned DP well, we can easily define the following states:

$ {d p \[ 0 \] \[ n \] := "maximum value ending at the" n "-th wheat ear where the previous chosen ear is taller"\
d p \[ 1 \] \[ n \] := "maximum value ending at the" n "-th wheat ear where the previous chosen ear is shorter" $

And write the following transition:

$ {d p \[ 0 \] \[ n \] := max \( d p \[ 1 \] \[ i \] \) + v \[ n \] \, #h(0em) f o r #h(0em) h \[ i \] > h \[ n \]\
d p \[ 1 \] \[ n \] := max \( d p \[ 0 \] \[ i \] \) + v \[ n \] \, #h(0em) f o r #h(0em) h \[ i \] < h \[ n \]\
1 lt.eq i < n $

We can see that this transition requires $O \( n \)$ time, so the total time complexity is $O \( n^2 \)$.
This is not enough to get full marks, so we need to optimize the time for finding the conditional maximum.

We can use a value-indexed segment tree or a Treap. At the time, I used a Treap with $O \( log n \)$ time complexity;
within the problem's constraints this is $log \( 10^5 \)$. A value-indexed segment tree also passes, though with higher complexity
of $O \( log C \)$, i.e., $log \( 2 times 10^9 \)$. Note that Treap has a larger constant (and longer code).

Our Treap uses $h\[i\]$ as the key and stores and maintains the maximum
$d p$ value. To query, cut at $k e y < h \[ i \]$
and $k e y > h \[ i \]$.

The answer is the maximum value across the entire DP table.

=== Other Resources
#link("https://hackmd.io/@Ccucumber12/Bk6lLyuxF#/")

#figure(image("../Images/DP5.png", width: 20.0%),
  caption: none
)

#link("https://cp-algorithms.com/dynamic_programming/divide-and-conquer-dp.html")

#figure(image("../Images/DP6.png", width: 20.0%),
  caption: none
)

=== Examples and Practice
#quote(block: true)[
*Hint:* The following problems do not necessarily require DP optimization.
]

==== Problem: 2021 LinDeng APCS Training Class Summer Contest E — Rush for Masks
*Problem Statement*

The pandemic is raging and the world is under lockdown. With COVID-19 spreading rapidly, masks have become a daily necessity. The timid YL wants to buy box after box of masks to fill his home, so that he can feel safer and worry less about going out. In YL's town there are $N$ pharmacies selling masks; the $i$-th pharmacy sells one box of masks for $p_i$ yuan and provides $s_i$ units of peace of mind. To prevent hoarding, DCD rules that only one box of masks may be purchased per pharmacy. However, the socially adept YL can use certain techniques to get around this restriction: at pharmacy $i$, by giving the pharmacist a red envelope of $r_i$ yuan, he can buy any number of boxes of masks there. However, he cannot do this without limit — he risks getting investigated and imprisoned if he is too conspicuous. To avoid attracting too much attention, YL can give out at most $K$ red envelopes. Today, YL went to the bank and withdrew $M$ yuan, intending to spend it all on masks. Under effective use of funds, what is the maximum total peace-of-mind YL can obtain?

*Input Format*

The first line contains three integers $N$, $M$, and $K$.

The following $N$ lines each contain three integers $p_i$, $s_i$, and $r_i$.

$1 lt.eq N lt.eq 100$, $0 lt.eq K lt.eq N$, $1 lt.eq M lt.eq 5000$

$1 lt.eq p_i lt.eq 5000$, $0 lt.eq r_i lt.eq 5000$, $1 lt.eq s_i lt.eq 10^6$

All input numbers are integers.

*Output Format*

Output the maximum total peace-of-mind YL can obtain.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 20 1`#linebreak()`3 4 2`#linebreak()`2 5 10`#linebreak()`7 9 3`#linebreak()`4 2 1`], [`26`],
)

==== Problem: TIOJ 1019 E. Jumping Up
*Problem Statement*

That's right, this problem is about a rabbit jumping on bells.

There is a very large tomato (nicknamed "Big Head" because of its big head) who loves this game,
but the mouse always has to move left and right, and one wrong move sends it falling down to start over — quite tiring. In the game, a rabbit starting from the first bell can jump at most to the next bell or the one after at each step, and once a bell is stepped on it disappears (sending the rabbit into the air).
Given the horizontal positions of $n$ bells, tell Big Head the minimum total horizontal distance traveled to get from the first bell all the way to the $n$-th bell.
(In this problem, we assume no flying birds will appear, and not every bell needs to be stepped on.)

p.s. The above story is purely fictional, but the test data is not (not funny...).

*Input Format*

The first line of the input contains a positive integer $T \( T lt.eq 1000 \)$, the total number of test cases.

Each of the following lines is one test case: first a positive integer $n$,
then $n$ horizontal offsets relative to the center of the screen, $d_1 \, d_2 \, dots.h.c \, d_n$ (from the first bell to the $n$-th bell).
Any $d_i \, 1 lt.eq i lt.eq n$ can be stored as a signed 32-bit integer.

*Output Format*

For each test case, output a positive integer representing the minimum total horizontal distance to jump from the first bell to the $n$-th bell.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`1`#linebreak()`9 1 2 3 4 5 6 7 8 9`], [`8`],
)

#quote(block: true)[
*Hint:* AtCoder DPC A Frog1
]

==== Problem: TIOJ 1288 D. \[IOI 1994\] Triangle Trip
*Problem Statement*

A triangle made of numbers. Find the maximum sum of a path from the top to the bottom.

Each step can only go to the lower-left or lower-right. The bottom row has no further moves.

The height of the triangle is between 1 and 100. All numbers in the triangle are between 0 and 99.

*Input Format*

The first number is $n$, the height of the triangle. You are smart enough to know what format follows.

*Output Format*

Output a number that looks like the answer.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`7`#linebreak()`3 8`#linebreak()`8 1 0`#linebreak()`2 7 4 4`#linebreak()`4 5 2 6 5`], [`30`],
)

==== Problem: TIOJ 1291 N Boxes M Balls
*Problem Statement*

Put $m$ distinct balls into $n$ identical boxes. How many ways are there? (Modulo $10^6$)

$n=m=0$ means end of test data.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`26 11`#linebreak()`21 45`#linebreak()`0 0`], [`678570`#linebreak()`517677`],
)

#quote(block: true)[
*Hint:* Can modular inverse be used?
]

==== Problem: CF 698A Vacations
*Problem Statement*

$V a s y a$ has $n$
days of vacation! So he decides to improve his $I T$ skills and do sports. $V a s y a$
knows the following information about each vacation day: whether the gym is open and whether an online contest is held that day. For the $i$-th day, there are four possible situations:

That day, the gym is closed and no contest is held; that day, the gym is closed and a contest is held;
that day, the gym is open and no contest is held; that day, the gym is open and a contest is held.

Each day, $V a s y a$
can choose to rest, participate in a contest (if there is one that day), or do sports (if the gym is open that day).

Find the minimum number of days $V a s y a$
must rest (meaning he cannot do sports and participate in a contest at the same time). $V a s y a$'s
only constraint is: he does not want to do the same activity on two consecutive days — that is, he will not do sports on two consecutive days, nor participate in a contest on two consecutive days.

*Input Format*

The first line contains a positive integer $n$ $\( 1 lt.eq n lt.eq 100 \)$ --- the number of vacation days for $V a s y a$.

The second line contains a space-separated sequence of integers $a_1 \, a_2 \, . . . \, a_n$
$\( 0 lt.eq a_i lt.eq 3 \)$, where:

$a_i = 0$: the gym is closed and no contest is held on day $i$;

$a_i = 1$: the gym is closed and a contest is held on day $i$;

$a_i = 2$: the gym is open and no contest is held on day $i$;

$a_i = 3$: the gym is open and a contest is held on day $i$.

*Output Format*

Output the minimum number of days $V a s y a$ must rest. Remember that $V a s y a$
refuses to do sports on two consecutive days or to participate in a contest on two consecutive days.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`1 3 2 0`], [`2`],
)

==== Problem: CF 1195 C Basketball
*Problem Statement*

Finally, a basketball court opened at SIS, and so Demid decided to hold a basketball training session. There are 2n students participating in Demid's training session, and he divided them into two rows, each with n students (exactly n students per row). Students are numbered 1 to n from left to right within each row.

Now Demid wants to select a basketball team. He will select players from left to right, and the index of each selected player (except the first) must be strictly greater than the index of the previously selected player. To avoid favoring one row, Demid cannot select two consecutive players from the same row. The first player can be selected from any of the 2n students (no additional restrictions), and a team can contain any number of players.

#figure(image("../Images/CF1195.png", width: 40.0%),
  caption: none
)

Demid believes that to form a perfect team, he should select players to maximize the total height of selected players. Help Demid find the maximum possible total height of a team he can select.

*Input Format*

The first line of input contains a positive integer $n \( 1 lt.eq n lt.eq 10^5 \)$ — the number of students per row.

The second line contains $n$ integers $h_(1 \, 1) \, h_(1 \, 2) \, dots.h.c \, h_(1 \, n) \( 1 lt.eq h_(1 \, i) lt.eq 10^9 \)$, where $h_(1 \, i)$ is the height of the $i$-th student in the first row.

The third line contains $n$ integers $h_(2 \, 1) \, h_(2 \, 2) \, dots.h.c \, h_(2 \, n) \( 1 lt.eq h_(2 \, i) lt.eq 10^9 \)$, where $h_(2 \, i)$ is the height of the $i$-th student in the second row.

*Output Format*

Output a single integer — the maximum possible total height of the team Demid can select.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`9 3 5 7 3`#linebreak()`5 8 1 4 5`], [`29`],
)

==== Problem: CF 474 D Flowers
*Problem Statement*

We see the groundhog preparing a small game for the mole's lunch. Now it is time for the groundhog's dinner; as everyone knows, groundhogs eat flowers. At each dinner, it eats some red and white flowers. Therefore, a dinner can be represented as a sequence of flowers, some white and some red.

However, to make the dinner tasty, there is a rule: the groundhog only wants to eat white flowers in groups of exactly $k$.

Now the groundhog wants to know how many ways it can eat $a$ to $b$ flowers. Since the number of ways can be very large, output it modulo $1000000007$ ($10^9 + 7$).

*Input Format*

The input contains multiple test cases.

The first line contains two integers $t$ and $k$
($1 lt.eq t \, k lt.eq 105$), where $t$ is the number of test cases.

The following $t$ lines each contain two integers $a i$ and $b i$
($1 lt.eq a i lt.eq b i lt.eq 105$), describing the $i$-th test case.

*Output Format*

Output to standard output, $t$ lines in total. The $i$-th line should contain the number of ways the groundhog can eat $a i$ to $b i$ flowers at dinner, modulo $1000000007$
($10^9 + 7$).

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`9 3 5 7 3`#linebreak()`5 8 1 4 5`], [`29`],
)

==== Problem: CF 4D Mysterious Present
*Problem Statement*

Peter decided to send birthday greetings to his friend in Australia and mail a card. To make the gift more mysterious, he decided to make a chain. A chain is a sequence of envelopes
$A = a_1 \, a_2 \, dots.h \, a_n$, where the width and height of the $i$-th
envelope are both strictly greater than those of the previous envelope. The size of the chain is the number of envelopes in the chain.

Peter wants to make the largest possible chain from the envelopes he has, and the chain must be able to contain a card. A card can be placed in the chain if the card's width and height are both less than the width and height of the smallest envelope in the chain. Rotating the card or envelopes is not allowed.

Peter has a large number of envelopes, but limited time, so this challenging task falls to you.

*Input Format*

The first line contains two integers $n$ and $w$, $h$
$\( 1 lt.eq n lt.eq 5000 \, 1 lt.eq w \, h lt.eq 10^6 \)$ —
the number of envelopes Peter has, and the width and height of the card. The following $n$
lines each contain two integers $w_i$ and $h_i$
$\( 1 lt.eq w_i \, h_i lt.eq 10^6 \)$ — the width and height of the $i$-th envelope.

*Output Format*

On the first line, output the maximum size of the chain. On the second line, output the envelope numbers forming the desired chain (space-separated), starting from the smallest envelope. Note that the card should fit in the smallest envelope. If there are multiple chains of maximum size, any one is acceptable.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`2 1 1`#linebreak()`2 2`#linebreak()`2 2`], [`1`#linebreak()`1`],
)

==== Problem: Luogu P3959 \[NOIP2017 Advanced Group\] Treasure
*Problem Statement*

Xiao Ming, participating in an archaeological excavation, received a treasure map marking $n$
treasure chambers buried underground, along with $m$
excavatable roads between these $n$ chambers and their lengths.

Xiao Ming is determined to personally excavate all the treasures. However, each treasure chamber is very far underground, meaning digging a tunnel from the surface to any given chamber is very difficult, while developing roads between chambers is comparatively easy.

Xiao Ming's determination moved the excavation sponsor, who agreed to sponsor the excavation of one free tunnel from the surface to a chamber of Xiao Ming's choosing.

On this basis, Xiao Ming also needs to consider how to excavate the roads between chambers. Roads already excavated can be traversed freely at no cost. Each time a new road is excavated, Xiao Ming and the archaeological team excavate the treasure in the chamber reachable by that road. Additionally, Xiao Ming does not want to develop useless roads — roads between two already-excavated chambers need not be developed.

The cost to excavate a new road is $upright(L) times upright(K)$, where $L$
is the length of the road, and $K$
is the number of chambers passed through from the sponsor-funded chamber to the starting chamber of this road (including both the sponsor-funded chamber and the starting chamber of this road).

Please write a program to help Xiao Ming choose the sponsor-funded chamber and the subsequent roads to excavate, minimizing the total construction cost, and output this minimum value.

*Input Format*

The first line contains two space-separated positive integers $n \, m$, representing the number of chambers and roads.

The following $m$
lines each contain three space-separated positive integers: the numbers of the two chambers connected by a road (numbered
$1$ to $n$), and the length $v$ of the road.

$1 lt.eq n lt.eq 12$, $0 lt.eq m lt.eq 10^3$, $v lt.eq 5 times 10^5$

*Output Format*

A single positive integer representing the minimum total cost.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4 5`#linebreak()`1 2 1`#linebreak()`1 3 3`#linebreak()`1 4 1`#linebreak()`2 3 4`#linebreak()`3 4 1`], [`4`],
)

==== Problem: Luogu P5785 \[SDOI2012\] Task Scheduling
*Problem Statement*

There are $n$ tasks to be processed on a machine, forming a sequence. The tasks are numbered $1$
to $n$, so the sequence is $1 \, 2 \, 3 dots.h.c n$. These $n$
tasks are divided into several batches, each containing consecutive tasks. Starting from time $0$,
the tasks are processed in batches. The time required to complete task $i$ alone is
$T_i$. Before each batch of tasks begins, the machine requires a startup time
$s$, and the time to complete that batch is the sum of the individual task times.

Note that all tasks in the same batch are completed at the same moment. The cost of each task is its completion time multiplied by a cost coefficient
$C_i$.

Find a grouping scheme that minimizes the total cost.

*Input Format*

The first line contains an integer $n$. The second line contains an integer $s$.

The following $n$ lines each contain a pair of integers $T_i$ and $C_i$, representing the individual completion time and cost coefficient of task $i$.

$1 lt.eq n lt.eq 3 times 10^5$, $1 lt.eq s lt.eq 2^8$, $lr(|T_i|) lt.eq 2^8$, $0 lt.eq C_i lt.eq 2^8$

*Output Format*

A single integer on one line, representing the minimum total cost.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1`#linebreak()`1 3`#linebreak()`3 2`#linebreak()`4 3`#linebreak()`2 3`#linebreak()`1 4`], [`4`],
)
