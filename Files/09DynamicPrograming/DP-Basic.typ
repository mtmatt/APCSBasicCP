#import "../../template.typ": *

== Fundamentals
=== What Is Dynamic Programming
Dynamic programming is actually neither "dynamic" nor "planning" in any intuitive sense—so why does it have this name?
The answer is that the person who invented this problem-solving approach had a boss who hated mathematics, so he chose a name that had nothing to do with math.

In practice, dynamic programming is mainly used to solve two types of problems: optimization problems and counting problems.
For example, in the Mathematics chapter we used it to compute combinations.

Before using dynamic programming, we must analyze the problem to determine whether it has *optimal substructure*.

=== Optimal Substructure
You might wonder what optimal substructure actually is. Simply put, it means:
the locally optimal solution can lead us to the globally optimal solution.

For counting problems, the locally computed values can guide us in computing the global result.

=== Recurrence Relation Notation
Going forward, we may express many recurrence relations. In mathematical notation, they are written as follows.

$ {d p_1 = d p_2 = 1\
d p_n = d p_(n - 1) + d p_(n - 2) \, n > 2 $

=== Memoized Recursion
The most convenient and lazy approach is to execute directly with recursion, but record repeated computations so they are not repeated. Using the Fibonacci sequence as an example:

#code(title: [Fibonacci Sequence with Recursive DP])[
```cpp
using ll=long long;
ll dp[N];
int fib(int n){
    if(n==1 || n==2){
        return 1;
    }

    if(dp[n]!=0){
        return dp[n];
    }

    return dp[n]=fib(n-1)+fib(n-2);
}
```
]

=== Iterative Tabulation
If we can guarantee that all values needed to compute $d p_n$ have been computed before we compute it,
we can use a loop to fill in the array iteratively. Using the Fibonacci sequence as an example:

#code(title: [Fibonacci Sequence with Iterative DP])[
```cpp
using ll=long long;
ll dp[N];
int init(int n){
    dp[1]=dp[2]=1;
    for(int i=3;i<N;++i){
        dp[i]=dp[i-1]+dp[i-2];
    }
}

int fib(int n){
    return dp[n];
}
```
]

This approach has the benefit of saving constant factors and is generally more intuitive.

=== Standard Approach
For those $d p$ problems that already have a given recurrence, they are the least mentally demanding type.
But the problems we must handle are definitely not so simple. Therefore, I need to tell you
some standard problem-solving methods.

+ Define the state—that is, define what $d p_i$ represents.

+ Write out the transition—that is, define the relationship between $d p_i$ and other states.

+ Determine the computation order: to conveniently use "iterative tabulation". (This includes defining the initial states.)

In principle, the standard approach can solve all problems (who said that?). However, there are many principles within the standard approach, and we need to improve our ability to apply them through practice.

=== Additional Notes
In the standard approach we mentioned $d p_i$, but sometimes we need more than one variable.
So if you see $d p_(i j)$ later, don't panic—it just means the state is defined by two variables.

=== Examples and Practice

==== Exercise: Implement a program that computes the following recurrence.

$ {d p_1 = d p_2 = 1\
d p_3 = 10\
d p_n = 3 d p_(n - 1) + d p_(n - 2) + d p_(n - 3) $

==== Exercise: Implement a program that computes the following recurrence, where $a$ is another input.

$ {d p_1 = a_1\
d p_2 = max \( a_1 \, a_2 \)\
d p_n = max \( d p_(n - 1) \, d p_(n - 2) + a_n \) $

==== Exercise: Implement a program that computes the following recurrence, where $a$ is another input.

$ {d p_1 = a_1\
d p_2 = max \( a_1 \, 2 a_2 \)\
d p_n = max \( d p_(n - 1) + a_n \, d p_(n - 2) + 2 a_n \) $
