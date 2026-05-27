== Mo's Algorithm
=== Sqrt Decomposition
Let's start with a classic segment tree problem: range sum queries.
Instead of splitting an interval into two halves, try splitting into roughly
$sqrt(n)$ blocks. The construction time is still $O \( n \)$,
and for queries, if a block is fully covered return it directly; otherwise count element by element.
The query complexity is $O \( sqrt(n) \)$.

You might wonder: there are better solutions, so why bother with a worse one?
Because sometimes it is not easy to figure out how to merge segments for a segment tree. In those cases,
if offline processing is allowed, Mo's Algorithm may apply.

=== Concept
Mo's Algorithm is based on sqrt decomposition of intervals — but not in the same way as above.
It is an offline algorithm, meaning we can reorder the queries.

Before applying it, we need to analyze the problem: if, given a known interval $\[ l \, r \]$,
we can quickly derive the answers for $\[ l - 1 \, r \]$ and $\[ l \, r + 1 \]$, then this algorithm can be used.

First, sort all query intervals using the following rule:

- If the left endpoints of two intervals fall in different blocks, the one with the smaller left endpoint comes first.

- Otherwise, the one with the smaller right endpoint comes first.

Swapping left and right here does not affect correctness. Then process the queries in this order, sliding the current interval
from $\[ l - 1 \, r \]$ and $\[ l \, r + 1 \]$ to reach each query's target interval, and record the answer.

Finally, re-sort the results by query index and output them. The time complexity is $O \( n t sqrt(n) \)$, where $t$ is the cost of
extending a known interval $\[ l \, r \]$ to $\[ l - 1 \, r \]$ or $\[ l \, r + 1 \]$.

==== Example: ZJ b417 Range Mode
*Problem Statement*

Given $10^5$ numbers and $10^5$ queries. For each query interval, output
the number of occurrences of the most frequent element in that interval, and how many distinct elements achieve that maximum frequency.

==== Approach
Since a segment tree is not easy to apply here, consider Mo's Algorithm. The first step is to determine how to extend a known interval $\[ l \, r \]$
to $\[ l - 1 \, r \]$ or $\[ l \, r + 1 \]$. I use two std::maps: the first, $f$,
stores the frequency of each number; the second, $f f$, stores how many distinct numbers have frequency $k$.

This allows each interval extension in $O \( log n \)$, giving a total time complexity of $O \( n log n sqrt(n) \)$.
Of course, using discretization can remove the `log` factor.

==== Code: Range Mode Solution

```
#define int long long
const int N=1000010;
using pii=pair<int,int>;

struct Query{
    int l,r,id;
    pii ans;
};

int n,m,k;
int a[N],f[N];
Query qq[N];

void solve(){
    cin>>n>>m;
    k=sqrt(n);
    for(int i=1;i<=n;++i){
        cin>>a[i];
    }

    for(int i=0;i<m;++i){
        cin>>qq[i].l>>qq[i].r;
        qq[i].id=i;
        qq[i].ans={0,0};
    }

    sort(qq,qq+m,[](Query a,Query b){
        return a.l/k!=b.l/k ? a.l/k<b.l/k : a.r<b.r;
    });

    map<int,int> ff;
    f[a[1]]++;
    f[a[2]]++;
    ff[f[a[1]]]++;
    ff[f[a[2]]]++;
    for(int i=0,l=1,r=2;i<m;++i){
        if(qq[i].l==qq[i].r){
            qq[i].ans={1,1};
            continue;
        }

        while(l!=qq[i].l || r!=qq[i].r){
            if(l<qq[i].l){
                ff[f[a[l]]]--;
                if(ff[f[a[l]]]<=0) ff.erase(f[a[l]]);
                f[a[l]]--;
                ff[f[a[l]]]++;
                l++;
            }

            if(l>qq[i].l){
                l--;
                ff[f[a[l]]]--;
                if(ff[f[a[l]]]<=0) ff.erase(f[a[l]]);
                f[a[l]]++;
                ff[f[a[l]]]++;
            }

            if(r<qq[i].r){
                r++;
                ff[f[a[r]]]--;
                if(ff[f[a[r]]]<=0) ff.erase(f[a[r]]);
                f[a[r]]++;
                ff[f[a[r]]]++;
            }

            if(r>qq[i].r){
                ff[f[a[r]]]--;
                if(ff[f[a[r]]]<=0) ff.erase(f[a[r]]);
                f[a[r]]--;
                ff[f[a[r]]]++;
                r--;
            }
        }

        auto it=ff.end(); it--;
        qq[i].ans=(*it);
    }

    sort(qq,qq+m,[](Query a,Query b){
        return a.id<b.id;
    });

    for(int i=0;i<m;++i){
        cout<<qq[i].ans.first<<" "<<qq[i].ans.second<<"\n";
    }
}
```

=== Examples and Practice
==== Problem: Luogu P1494 \[National Training Team\] Xiao Z's Socks
*Problem Statement*

As a disorganized person, Xiao Z
spends a lot of time every morning picking a matching pair of socks from a colorful pile. Finally, one day, Xiao Z
can no longer endure this tedious process, so he decides to leave it to fate...

Specifically, Xiao Z numbers the $N$ socks from $1$ to $N$, then randomly picks two socks
from the range $L$ to $R$ ($L lt.eq R$). Even though Xiao Z
doesn't care whether the two socks match as a pair, or even whether they're left and right foot socks, he cares a lot about color — wearing two socks of different colors would be embarrassing.

Your task is to tell Xiao Z the probability that two socks drawn randomly from the range $\[ L \, R \]$
have the same color. Since Xiao Z
wants this probability to be as high as possible, he may ask about multiple ranges.

However, if $L = R$, handle this case specially and output 0/1.

*Input Format*

The first line contains two positive integers $N$ and $M$. $N$ is the total number of socks, $M$
is the number of queries. The next line contains $N$ positive integers $C_i$, where $C_i$
is the color of the $i$-th sock (same color means same number). The following $M$
lines each contain two positive integers $L$ and $R$, representing a query range.

$N$ and $M$ do not exceed 50000, $1 lt.eq L < R lt.eq N$, $C_i lt.eq N$

*Output Format*

Output $M$ lines. For each query, print a fully reduced fraction
$A \/ B$ representing the probability of drawing two socks of the same color from range $\[ L \, R \]$.
If the probability is $0$, print
0/1. Note that the fraction must be fully reduced. (See the sample.)

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6 4`#linebreak()`1 2 3 3 3 2`#linebreak()`2 6`#linebreak()`1 3`#linebreak()`3 5`#linebreak()`1 6`], [`2/5`#linebreak()`0/1`#linebreak()`1/1`#linebreak()`4/15`],
)

==== Problem: Luogu P1903 \[National Training Team\] Count Colors / Maintain Queue
*Problem Statement*

Momo purchased a set of $N$
colored pens (some may share the same color), arranged in a row. You need to answer Momo's queries. Momo issues the following commands:

$Q med L med R$ asks how many distinct colors appear among pens $L$ through $R$.

$R med P med C o l$ replaces the $P$-th pen with color $C o l$.

Can you figure out what you need to do?

*Input Format*

Line $1$ contains two integers
$N$ and $M$, representing the initial number of pens and the number of operations.

Line $2$ contains $N$ integers representing the color of the $i$-th pen in the initial arrangement.

Lines $3$ through $2 + M$
each describe one operation in the format given above.

*Output Format*

For each Query operation, output a single number on the corresponding line representing the number of distinct colors among pens $L$ through $R$.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6 5`#linebreak()`1 2 3 4 5 5`#linebreak()`Q 1 4`#linebreak()`Q 2 6`#linebreak()`R 1 2`#linebreak()`Q 1 4`#linebreak()`Q 2 6`], [`4`#linebreak()`4`#linebreak()`3`#linebreak()`4`],
)

#quote(block: true)[
*Hint:* Think about how to handle updates.
]

==== Problem: Luogu P2464 \[SDOI2008\] Gloomy Xiao J
*Problem Statement*

Xiao J
is a librarian at the National Library, responsible for managing an enormous bookshelf. Despite his diligence, the shelf is so huge that his efficiency is always low, putting him at risk of being fired — a constant source of gloom.

Specifically, the shelf has $N$ slots numbered $1$ to
$N$. Each slot holds one book, and each book has a specific code.

Xiao J's work involves two types of tasks:

The library regularly acquires new books. Since the shelf is always full, a book must be removed from some slot and replaced with the new acquisition.

Xiao J
must answer customer queries: a customer asks how many books with a specific code appear in a consecutive range of slots.

For example, with $N$ slots, the initial book codes are
$A_1 \, A_2 \, dots.h \, A_N$.

A customer queries slots $1$ to $3$
for books with code "$K$" and receives the answer: $X$.

A customer queries slots $1$ to $3$
for books with code "$K$" and receives the answer: $Y$.

The library acquires a new book with code "$P$" and places it in slot $A$.

A customer queries slots $1$ to $3$
for books with code "$K$" and receives the answer: $Z$.

A customer queries slots $1$ to $3$
for books with code "$K$" and receives the answer: $W$.

......

Your task is to write a program to answer each customer's query.

*Input Format*

The first line contains two integers $N \, M$, meaning $N$ slots and $M$ operations.

The next line contains $N$ integers $A_1 \, A_2 \, dots.h \, A_N$, where $A_i$
is the code of the book initially in slot $i$.

The following $M$ lines each describe one operation, starting with a character.

If the character is C, the library acquires a new book; it is followed by two integers
$A \, P$ ($1 lt.eq A lt.eq N$), placing the new book with code $P$ in slot $A$.

If the character is Q, a customer makes a query; it is followed by three integers
$A \, B \, K$ ($1 lt.eq A lt.eq B lt.eq N$), asking how many books with code $K$ appear in slots $A$ through $B$ (inclusive).

$1 lt.eq N \, M lt.eq 10^5$; all book codes are positive integers not exceeding $2^31 - 1$.

*Output Format*

For each customer query, output a single integer representing the answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 5`#linebreak()`1 2 3 4 5`#linebreak()`Q 1 3 2`#linebreak()`Q 1 3 1`#linebreak()`C 2 1`#linebreak()`Q 1 3 2`#linebreak()`Q 1 3 1`], [`1`#linebreak()`1`#linebreak()`0`#linebreak()`2`],
)

==== Problem: Luogu P2709 Xiao B's Queries
*Problem Statement*

Xiao B has an integer sequence $a$ of length $n$ with values in $\[ 1 \, k \]$. He has $m$
queries. Each query gives an interval $\[ l \, r \]$ and asks for:

$ sum_(i = 1)^k c_i^2 $

where $c_i$ is the number of occurrences of $i$ in $\[ l \, r \]$.
Please help Xiao B answer the queries.

*Input Format*

The first line contains three integers $n \, m \, k$.

The second line contains $n$ integers representing Xiao B's sequence.

The following $m$ lines each contain two integers $l \, r$.

For $100 %$ of the data: $1 lt.eq n \, m \, k lt.eq 5 times 10^4$

*Output Format*

Output $m$ lines, each containing a single integer, corresponding to the answer for one query.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`6 4 3`#linebreak()`1 3 2 1 1 3`#linebreak()`1 4`#linebreak()`2 6`#linebreak()`3 5`#linebreak()`5 6`], [`6`#linebreak()`9`#linebreak()`5`#linebreak()`2`],
)
