== Classical Problems
=== Introduction
Next, we will look at many classical DP problems.

=== Fibonacci Variations
The following problems are all related to the Fibonacci sequence, but with modified transition relations.

==== Example: AtCoder DP Contest A. Frog
*Problem Statement*

There are $N$ stones numbered $1 \, 2 \, dots.h.c \, N$. For each
$i med \( 1 lt.eq i lt.eq N \)$, the height of stone $i$ is $h_i$.

A frog starts at stone $1$. It will repeat the following action some number of times until it reaches stone $N$:

If the frog is currently at stone $i$, it jumps to stone $i + 1$ or stone
$i + 2$. Here, a cost of $\| h_i - h_j \|$ is incurred, where $j$
is the stone it jumps to. Find the minimum total cost the frog may incur before reaching stone $N$.

*Input Format*

The input is given from standard input in the following format:

$N$

$h_1 med h_2 med dots.h.c med h_N$

All input values are integers. $2 lt.eq N lt.eq 10^5$, $1 lt.eq h_i lt.eq 10^4$

*Output Format*

Print the minimum possible total cost incurred.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`#linebreak()`10 30 40 20`], [`30`],
  [Sample Input 2], [Sample Output 2],
  [`6`#linebreak()`30 10 60 10 60 50`], [`40`],
)

==== Idea

For this problem we can follow our standard approach, so first we define the state.

What state can satisfy our needs? For simple problems, we can define the state based on what the problem ultimately asks for. In this problem, the question asks for the minimum total cost before the frog reaches stone $N$, so we can define:

$ d p_n := "the minimum total cost to reach stone" n $

Next, we need the transition. The problem states we can only move forward 1 or 2 steps,
so we must have come from stone $n - 1$ or stone $n - 2$. Taking the better of these two cases, we get:

$ {d p_1 = 0 \, #h(0em) d p_2 = \| a_1 - a_2 \|\
d p_n = min \( d p_(n - 1) + \| a_n - a_(n - 1) \| \, d p_(n - 2) + \| a_n - a_(n - 2) \| \) $

The initial state is critical: since stone 2 can only be reached from stone 1, there is only one way to reach it.

Time complexity is $O \( n \)$.

==== Example: ZJ b587 Tri Tiling
*Problem Statement*

Given a $3 times n$ floor, tile it completely with $1 times 2$ tiles. How many ways are there?

*Input Format*

Each line contains an integer $n$ representing a $3 times n$
floor, $0 lt.eq n lt.eq 30$; $n = - 1$ means end of input.

*Output Format*

For each input, output the number of valid tilings.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`8`#linebreak()`-1`], [`153`],
)

==== Idea

The problem looks tricky. When you encounter such a problem, consider getting out pencil and paper.
First, as usual, we define the state. Even though this problem is not so simple, we can try starting from the problem's requirement.

$ d p_n := "the number of ways to tile a" 3 times n #h(0em) "floor with" 1 times 2 #h(0em) "tiles" $

At this point we might first decide on the initial state: if $n lt.eq 1$, then $d p_n = 0$.
If $n = 2$, then $d p_n = 3$ (you can verify this by drawing a diagram). Next, we find that whenever $n$ is odd,
it is impossible to tile the floor. So we only need to consider even $n$.

#figure(image("../Images/DP1.png", width: 50.0%),
  caption: none
)

#figure(image("../Images/DP2.png", width: 50.0%),
  caption: none
)

Based on the figures above and the first figure on the next page, you might think the DP relation looks like this:

$ {d p_0 = 1 \, d p_2 = 3\
d p_n = 3 times d p_(n - 2) + 2 times d p_(n - 4) $

But when you happily submit your answer, you find it is wrong. Are there states you haven't considered?

At this point we need to re-examine our work for errors — for example, overcounting or undercounting. In this problem, we undercounted. (I just realized this while writing, and the solution came to me at the same moment, so it happens to serve as an example.)

#figure(image("../Images/DP3.png", width: 80.0%),
  caption: none
)

Generalizing this, we obtain a new DP relation:

$ {d p_0 = 1 \, d p_2 = 3\
d p_n = 3 times d p_(n - 2) + 2 times sum_(i = 1)^(n / 2) d p_(n - 2 i) $

Additionally, though not required for this problem, prefix sums and matrix exponentiation can be used to handle this, with the lowest complexity being $O \( log n \)$.

==== Solution Code: ZJ b587

```
#include<bits/stdc++.h>
using namespace std;

using ll=long long;

ll dp[50];

int main(){
    ios::sync_with_stdio(0);cin.tie(0);

    int n;

    dp[0]=1;
    dp[2]=3;
    for(int i=4;i<=30;i+=2){
        dp[i]=3*dp[i-2];
        for(int j=4;j<=i;j+=2){
            dp[i]+=2*dp[i-j];
        }
    }

    while(cin>>n && n!=-1){
        if(n&1){
            cout<<0<<"\n";
        }else{
            cout<<dp[n]<<"\n";
        }
    }
}
```

=== Longest Common Subsequence
Also known as LCS (Longest Common Subsequence). The problem is as follows:

Given two strings, find the length of their longest common subsequence—that is, the longest length achievable by deleting some characters from each string (without changing order) so that both strings become equal. For example, the LCS of "aabbaa" and "aba" is 3.

For this problem, a single variable is clearly insufficient, so we use two variables. First, define the state. Through intuition we know we can define the state as:

$ d p_(n \, m) := "the LCS of the first" n "characters of string" a "and the first" m "characters of string" b $

With this definition, we can derive the transition. First, if either $n$ or $m$ is $0$, there cannot be any LCS, so LCS must be $0$. Then, for $d p_(n \, m)$, there are two cases: whether the $n$-th character of string $a$ equals the $m$-th character of string $b$. If they are equal, we can take $d p_(n - 1 \, m - 1)$ and add $1$, since the current $n$-th and $m$-th characters match. Otherwise, we can only look at the previous step, which has two options: advance $a$ by one, or advance $b$ by one.

$ {d p_(i \, 0) = d p_(0 \, j) = 0\
d p_(n \, m) = max \( d p_(n - 1 \, m) \, #h(0em) d p_(n \, m - 1) \) \, #h(0em) i f #h(0em) a_n eq.not b_m\
d p_(n \, m) = d p_(n - 1 \, m - 1) + 1 \, #h(0em) e l s e $

In practice, a 2D array can be used. Complexity is $O \( n times m \)$.

==== Solution Code: LCS

```
int dp[N][M];

int LCS(string a,string b){
    for(int i=1;i<=a.size();++i){
        for(int j=1;j<=b.size();++j){
            if(a[i-1]!=b[i-1]){
                dp[i][j]=max(dp[i][j-1],dp[i-1][j]);
            }else{
                dp[i][j]=dp[i-1][j-1]+1;
            }
        }
    }
    return dp[a.size()][b.size()];
}
```

=== Longest Increasing Subsequence
Another very classical problem is LIS (Longest Increasing Subsequence).
The goal is to delete as few elements as possible so that the remaining elements are strictly increasing (or non-strictly, depending on the problem).

This problem is not trivial. First, define the state:

$ d p_n := "the LIS ending at" a_n $

Next, since we need the subsequence to be increasing, we must find all elements before position $n$ that are smaller than $a_n$ and try to append $a_n$ after them. However, we cannot determine which one gives the longest result, so we must scan all of them—which gives $O \( n^2 \)$ complexity. The transition is:

$ {d p_1 = 1\
d p_n = max \( d p_i \) + 1 \, #h(0em) i < n #h(0em) a n d #h(0em) a_n gt.eq a_i $

If we only need to output the length, there is a way to speed up the computation to
$O \( n log \( n \) \)$ using binary search.

==== Robinson-Schensted-Knuth Algorithm

Track the position of each number in the LIS. Place each number as far back as possible to allow longer extensions. Use binary search to speed up the position-finding step.

==== Solution Code: LIS Length

```
int LIS(vector<int> &v){
    vector<int> lis;
    for(int i=0;i<v.size();++i){
        int it=lower_bound(lis.begin(),lis.end(),v[i])-lis.begin();
        if(it==lis.size()){
            lis.emplace_back(v[i]);
        }else{
            lis[it]=v[i];
        }
    }
    return lis.size();
}
```

If we need the lexicographically smallest LIS, the only $O \( n log \( n \) \)$ solution I have thought of is to use a Treap to query the minimum value; this will be mentioned again in the data structure optimization section.

=== Knapsack Problems
I recommend reading "Knapsack Problems: Nine Lectures"—it covers many different variants. We will only go over a few here.

The most classic knapsack problem is the 0/1 knapsack: each item can either be taken or not taken (hence 0/1). Each item has two values, $w_i$ and $v_i$. We want to maximize the total $v_i$ subject to the constraint that the total $w_i$ does not exceed $W$.
First, we might think of enumerating all possibilities, which has time complexity $O \( 2^n \)$.

However, given the constraints $n lt.eq 100 \, W lt.eq 10^5$ where $W$ is the total weight limit,
$2^n$ will not pass, so we need to develop a new algorithm.

First, define the state. Since neither $n$ nor $W$ is very large, we can define:

$ d p \[ n \] \[ w \] := "the maximum value achievable using the first" n "items with total weight not exceeding" w $

With this, we can set up the transition. Similar to LCS, we need to consider whether we can take the $i$-th item.

$ {d p \[ 0 \] \[ j \] = 0\
d p \[ i \] \[ 0 \] = 0\
d p \[ i \] \[ j \] = d p \[ i - 1 \] \[ j \] \, #h(0em) i f #h(0em) w \[ i \] > j\
d p \[ i \] \[ j \] = max \( d p \[ i - 1 \] \[ j \] \, d p \[ i - 1 \] \[ j - w \[ i \] \] + v \[ i \] \) $

Both time and space complexity are $O \( n W \)$. Given the small input constraints, this is acceptable.

==== Solution Code: 0/1 Knapsack

```
ll dp[105][100010],v[105],w[105];

int main(){
    // input
    for(int i=1;i<=n;i++){
        for(int j=1;j<=W;j++){
            if(w[i]>j){
                dp[i][j]=dp[i-1][j];
            }else{
                dp[i][j]=max(dp[i-1][j],dp[i-1][j-w[i]]+v[i]);
            }
        }
    }
}
```

Next, another variant is the unbounded knapsack, where each type of item can be taken any number of times.
Given $n$ types of items, item $i$ has weight $w_i$ and value $v_i$, and the knapsack capacity is $W$.
What is the maximum total value?

$n lt.eq 100 \, W lt.eq 10^5$

For this problem, we can use a similar transition. The only difference is that an item can be used multiple times. So we change $d p \[ i - 1 \] \[ j - w \[ i \] \] + v \[ i \]$ to $d p \[ i \] \[ j - w \[ i \] \] + v \[ i \]$,
because $d p \[ i \] \[ j - w \[ i \] \] + v \[ i \]$ is the maximum value that includes using item $i$ again.

$ {d p \[ i \] \[ j \] = d p \[ i - 1 \] \[ j \] \, #h(0em) i f #h(0em) w \[ i \] > j\
d p \[ i \] \[ j \] = max \( d p \[ i - 1 \] \[ j \] \, d p \[ i \] \[ j - w \[ i \] \] + v \[ i \] \) $

==== Solution Code: Unbounded Knapsack

```
ll dp[105][100010],v[105],w[105];

int main(){
    // input

    for(int i=1;i<=n;i++){
        for(int j=1;j<=W;j++){
            if(w[i]>j){
                dp[i][j]=dp[i-1][j];
            }else{
                dp[i][j]=max(dp[i-1][j],dp[i][j-w[i]]+v[i]);
            }
        }
    }
}
```

The next variant is the bounded knapsack, where item $i$ can be taken at most $c_i$ times. The simplest approach is to split item $i$ into $c_i$ copies that can each be taken at most once, then apply the 0/1 knapsack solution.

However, this gives time and space complexity of $O \( sum c_i times W \)$. Given $n lt.eq 100 \, c_i lt.eq 100 \, W lt.eq 10^5$, this would result in TLE or MLE, so we need a more efficient approach.

Recall binary exponentiation? We can apply the same idea here: split each item into $O \( log \( c_i \) \)$ pieces. This gives us an $O \( sum log \( c_i \) times W \)$ solution (using 0/1 knapsack).

==== Solution Code: Item Splitting

```
using vec=vector<int>;
using pvv=pair<vec,vec>;

pvv CutItem(vector<int> &w,vector<int> &v,vector<int> &c){
    int n=w.size();
    vector<int> rw(1,0),rv(1,0);

    cin>>n;
    for(int i=0;i<n;++i){
        int c=c[i];
        for(int am=1; am<=c; c-=am,am<<=1){
            rw.emplace_back(w[i]*am);
            rv.emplace_back(c[i]*am);
        }

        if(c>0){
            rw.emplace_back(w[i]*c);
            rv.emplace_back(c[i]*c);
        }
    }

    return pvv{rw,rv};
}
```

Next, let's look at the grouped knapsack problem. Items are divided into $i$ groups with $n$ items in total; all other constraints are the same as above.

In this case, we redefine the state:

$ d p \[ i \] \[ j \] := "the maximum value using the first" i "groups of items with total weight not exceeding" j $

The transition tries every item in each group using the 0/1 knapsack approach.
Time complexity is $O \( n W \)$.

==== Solution Code: Grouped Knapsack

```
ll dp[105][100010],v[105],w[105];

int main(){
    // input
    // suppose there are k groups
    for(int i=1;i<=k;i++){
        for(int u=1;u<=a[i];u++){
            for(int j=1;j<=W;j++){
                if(w[i]>j){
                    dp[i][j]=dp[i-1][j];
                }else{
                    dp[i][j]=max(dp[i-1][j],dp[i-1][j-w[i][u]]+v[i][u]);
                }
            }
        }
    }
}
```

Finally, let's look at the multi-constraint knapsack. For example, taking an item also consumes time $t_i$, and the total time available is $T$, while the knapsack also has a weight limit $W$.

This problem is not very difficult. If you have learned the knapsack problems above, you should be able to quickly guess that the transition applies the knapsack over both constraints simultaneously.

$ d p \[ n \] \[ w \] \[ t \] := "the maximum value using the first" n "items with total weight" lt.eq w "and total time" lt.eq t $

$ {d p \[ i \] \[ j \] \[ k \] = d p \[ i - 1 \] \[ j \] \[ k \] \, #h(0em) i f #h(0em) w \[ i \] > j #h(0em) o r #h(0em) t \[ i \] > w\
d p \[ i \] \[ j \] \[ k \] = max \( d p \[ i - 1 \] \[ j \] \, d p \[ i - 1 \] \[ j - w \[ i \] \] \[ k - t \[ i \] \] + v \[ i \] \) $

The time and space complexity is $O \( n W T \)$.

=== DP on DAGs
A DAG is a directed acyclic graph. Therefore, when problems occur on DAGs, they can usually be solved using DFS with memoization or topological sort.

==== Example: 2021 YiZhong Intra-School Contest Final — Longest Path on a DAG
*Problem Statement*

Given a DAG with $n$ nodes and $m$ edges, where each node is identified by a string, find the length of the longest path in the graph.

*Input Format*

The first line contains $n$ and $m$. ($n lt.eq 100 \, m lt.eq 1000$)

The following $m$ lines each contain two strings $a$ and $b$, representing a directed edge from $a$ to $b$.

*Output Format*

The length of the longest path on the DAG.

==== Idea

The test data at the time was weak, so DFS could pass directly. But considering topological sort, we find it can be done in $O \( n \)$.

=== Examples and Practice
==== Problem: Atcoder DPC B Frog 2
*Problem Statement*

There are $N$ stones numbered $1 \, 2 \, dots.h.c \, N$. For each stone $i$
($1 lt.eq i lt.eq N$), its height is $h_i$.

A frog starts at stone $1$. It will repeat the following action multiple times until it reaches stone $N$:

If the frog is currently at stone $i$, it can jump to any of: stone
$i + 1 \, i + 2 \, dots.h.c \, i + K$. A cost of
$\| h_i - h_j \|$ is incurred, where $j$ is the stone jumped to. Find the minimum total cost before the frog reaches stone $N$.

*Input Format*

All input values are integers, given in the following format:

$N$

$K$

$h_1 \, h_2 \, dots.h.c \, h_N$

$2 lt.eq N lt.eq 10^5$, $1 lt.eq K lt.eq 100$, $1 lt.eq h_i lt.eq 10^4$

*Output Format*

Output the minimum possible total cost.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 3`#linebreak()`10 30 40 50 20`], [`30`],
)

==== Problem: Atcoder DPC C Vacation
*Problem Statement*

Taro's summer vacation starts tomorrow, and he decides to plan it now.

The vacation lasts $N$ days. On each day $i$
$\( 1 lt.eq i lt.eq N \)$, Taro will choose one of the following activities to do:

A: Swim in the sea. Gain $a_i$ happiness. B: Catch bugs in the mountains. Gain $b_i$
happiness. C: Do homework at home. Gain $c_i$ happiness.
Since Taro gets bored easily, he cannot do the same activity on two consecutive days.

Find the maximum possible total happiness Taro can obtain.

*Input Format*

All input values are integers.

The input format is as follows:

$N$

$a_1 quad b_1 quad c_1$

$a_2 quad b_2 quad c_2$

$dots.v$

$a_N quad b_N quad c_N$

$1 lt.eq N lt.eq 10^5$, $1 lt.eq a_i \, b_i \, c_i lt.eq 10^4$

*Output Format*

Output the maximum possible total happiness Taro can obtain.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`10 40 70`#linebreak()`20 50 80`#linebreak()`30 60 90`], [`210`],
)

==== Problem: Atcoder DPC E Knapsack 2
*Problem Statement*

There are $N$ items numbered $1$ to $N$. For each $i$
($1 lt.eq i lt.eq N$), item $i$ has weight $w_i$ and value $v_i$.

Taro decides to choose some items to carry home in a knapsack. The knapsack's capacity is
$W$, meaning the total weight of chosen items must not exceed $W$.

Find the maximum possible total value of items Taro carries home.

*Input Format*

All input values are integers.

The input format is as follows:

$N med W$

$w_1 med v_1$

$w_2 med v_2$

$dots.v$

$w_N med v_N$

$1 lt.eq N lt.eq 100$

$1 lt.eq W lt.eq 10^9$

$1 lt.eq w_i lt.eq W$

$1 lt.eq v_i lt.eq 10^3$

*Output Format*

Output the maximum possible total value of items Taro carries home.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 8`#linebreak()`3 30`#linebreak()`4 50`#linebreak()`5 60`], [`90`],
)

==== Problem: Atcoder DPC F LCS
*Problem Statement*

Given two strings $s$ and $t$. Find the longest string that is a subsequence of both $s$ and $t$.

Note: A subsequence of string $x$ is a string obtained by deleting zero or more characters from $x$ and concatenating the remaining characters without changing their order.

*Input Format*

The input is given in the following format:

$s$

$t$

$s$ and $t$ are strings consisting of lowercase English letters.
$1 lt.eq \| s \| \, \| t \| lt.eq 3000$

*Output Format*

Output the longest string that is a subsequence of both $s$ and $t$. If there are multiple such strings, any one of them is acceptable.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`axyb`#linebreak()`abyxb`], [`axb`],
)

==== Problem: Atcoder DPC H Grid 1
*Problem Statement*

Given a grid with $H$ horizontal rows and $W$ vertical columns. We denote the cell at row $i$ and column $j$ as $\( i \, j \)$.

For each $\( i \, j \)$, the content of cell $\( i \, j \)$ is represented by character $a_(i \, j)$.
If $a_(i \, j)$ is `.`, cell $\( i \, j \)$ is an empty cell; if $a_(i \, j)$ is `#`, cell $\( i \, j \)$
is a wall cell. It is guaranteed that cells $\( 1 \, 1 \)$ and $\( H \, W \)$ are empty cells.

Taro starts from cell $\( 1 \, 1 \)$ and can move right or down to an adjacent empty cell at each step, with the goal of reaching $\( H \, W \)$.

Find the number of paths from cell $\( 1 \, 1 \)$ to $\( H \, W \)$. Since the answer may be very large, output it modulo $10^9 + 7$.

*Input Format*

The input is given in the following format:

$H$ $W$ $a_(1 \, 1) dots.h.c a_(1 \, W)$

$dots.v$

$a_(H \, 1) dots.h.c a_(H \, W)$

$H$ and $W$ are integers. $2 lt.eq H \, W lt.eq 1000$. $a_(i \, j)$
is either `.` or `#`. Cells $\( 1 \, 1 \)$ and $\( H \, W \)$ are empty.

*Output Format*

Output the number of paths from cell $\( 1 \, 1 \)$ to $\( H \, W \)$, modulo
$10^9 + 7$.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 4`#linebreak()`...#`#linebreak()`.#..`#linebreak()`....`], [`3`],
)

==== Problem: ZJ b589 Super Marathon Race
*Problem Statement*

A super marathon race is about to begin. In the game, players must run different routes each day.
Suppose the game has $n$ routes in total; each route has a different point value.
If a player cannot complete a route within the time limit, they score zero for that route;
if a player completes a route within the time limit, they earn the route's designated score;
if a player completes a route in less time than the limit, they can earn double the points.

Xiao Ai wants to participate in this race. If she runs a route at normal speed,
she earns the base score; if she runs at full speed, she earns double the score,
but she must rest on the next route (scoring 0 due to fatigue).
Write a program to help Xiao Ai determine which routes she should run at full speed to maximize her total score.

*Input Format*

The input contains multiple test cases. Each test case has two lines: the first line contains a number $n$
representing the number of routes, $1 lt.eq n lt.eq 40$; the second line contains $n$
integers representing the base score of each route,
$10 lt.eq P 1 \, P 2 \, dots.h.c \, P n lt.eq 100$.

When $n = 0$, it indicates end of input.

*Output Format*

For each test case, output the best total score on a single line.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`90 60 10`#linebreak()`0`], [`210`],
)

#quote(block: true)[
*Hint:* Consider adding more states, or giving states additional definitions.
]

==== Problem: CF 455A Boredom
*Problem Statement*

Alex
does not like boredom. So whenever he gets bored, he invents games to play. One long winter night, he thought of a game and decided to play it.

Given a sequence of $n$ integers
$a$. A player may perform multiple steps. In each step, the player chooses one element of the sequence (say
$a_k$) and removes it, while also removing all elements equal to $a_(k + 1)$ and $a_(k - 1)$.
This step gives the player $a_k$ points.

Alex is a perfectionist, so he decides to maximize his score. Help him.

*Input Format*

The first line contains an integer $n$($1 lt.eq n lt.eq 10^5$), representing how many numbers are in Alex's sequence.

The second line contains $n$ integers
$a_1 \, a_2 \, dots.h.c \, a_n$($1 lt.eq a_i lt.eq 10^5$).

*Output Format*

Output a single integer representing the maximum score Alex can obtain.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`9`#linebreak()`1 2 1 3 2 2 2 2 3`], [`10`],
)

#quote(block: true)[
*Hint:* The state is somewhat unusual — observe the range of values.
]
