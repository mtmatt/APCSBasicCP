#import "../../template.typ": *

== Topological Sort
=== Concept
Before discussing topological sort, we need to introduce the DAG (Directed Acyclic
Graph).

A DAG is, as the name implies, a directed graph with no cycles. This means that
even without an isv visited check, you will never encounter an infinite loop.

Figure 6.1 shows an example of a DAG.

As for what topological sort actually is — I honestly forgot, so I looked it up (I don't use it that often).
Here it is: if there is an edge $\( a \, b \)$, then a must be visited before b.

We can handle this by computing the in-degree of each vertex. If the in-degree is 0, push the vertex into the queue.

#block[
The in-degree ind\[x\] is the number of edges pointing into x.

]
=== Implementation
#code(title: [Topological Sort])[
  ```cpp
vector<int> ans;
void topological_sort(){
    queue<int> topo;
    int f=0,b=0;
    for(int i=0;i<n;i++){
        if(ind[i]==0){
            topo.push(i);
            b++;
        }
    }

    while(!topo.empty()){
        int now=topo.front();
        topo.pop();
        ans.push_back(now);
        for(auto next:g[now]){
            if(--ind[next]==0){
                topo.push(next);
                b++;
            }
        }
    }
}
  ```
]

=== Examples and Practice
==== Problem: TIOJ 1092 A. Hop-Scotch Game
*Problem Statement*

Mimi and Moumou are childhood friends who have played together since they were young (even though they are only in third grade now). The two love inventing new games whenever their old ones get boring.

Today they are designing a new game with the following rules:

Draw N circles on the ground, numbered 1 to N, with circle 1 as the start and circle N as the finish.

Draw one-way arrows between the N circles in any configuration. Each arrow connects two distinct circles; if an arrow goes from circle a to circle b, you can jump from a to b during the game.

Check the diagram from steps 1 and 2: make sure every circle numbered 1 through
N-1 has a path to the finish, and there are no loops (no circle can reach itself). There is at most one arrow from any circle a to any circle b.

Two players start the game: one stands on the start (circle 1), the other stands outside the diagram.

During the game, if player A is on circle C and player B is outside, player B chooses one of the outgoing arrows from C and moves to the circle it points to, while player A steps outside.

The two players repeat step 5 until one of them reaches the finish. The first to reach the finish wins.

*Input Format*

The input contains multiple test cases. The first line of each test case has two numbers
$N \, E \( 1 lt.eq N lt.eq 10000 \, #h(0em) E lt.eq 10 N \)$. The following E
lines each have two numbers $a \, b \( 1 lt.eq a \, b lt.eq N \)$, indicating an arrow from a
to b. You may assume the input always represents a valid graph. The last line "0 0" marks the end of input.

*Output Format*

Assume the game is played by Mimi and Moumou, and both play optimally — if there is a winning strategy they will take it.

For each test case, output the name of the winner (Mimi or Moumou) on a single line.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 6`#linebreak()`1 2`#linebreak()`1 3`#linebreak()`2 3`#linebreak()`2 4`#linebreak()`3 5`#linebreak()`4 5`#linebreak()`Mimi`#linebreak()`0 0`], [`Moumou`],
)
==== Problem: Sprout OJ 165 Advancing the Front Line
*Problem Statement*

If you have played strategy games, especially
AoC, you are certainly familiar with the concept of a "front line."
In general, the idea is: if the enemy has set up their defenses well, then before capturing certain strongholds,
you must first capture others — otherwise your forces will either be blocked by walls
or caught in a pincer attack and wiped out.

In a typical 1v1 duel, both sides usually rush each other, so neither has much of a base to defend
and this isn't a big concern. But when the player count grows — say, a 4v4 team battle —
as the game goes on, the relationships between strongholds can become very complex:
capturing A requires capturing B and C first, capturing B requires D and E first, and so on.
To avoid heavy losses, you send out a large number of scouts who sacrifice themselves for the greater good,
scouting out the layout and positions of all strongholds. Now it is time to form a battle plan.
Given the prerequisite relationships for capturing each stronghold, can you devise a plan
to take all strongholds in an order that satisfies every requirement —
allowing you to fight the enemy without ever being surrounded?

*Input Format*

The first line of input is a positive integer T. There will then be T
test cases. The first line of each test case has two non-negative integers
n and m, representing the number of strongholds and the number of prerequisite relationships. Lines 2 through $m + 1$
each contain two integers a and b
$\( 0 lt.eq a \, b lt.eq n - 1 \)$, meaning stronghold a must be captured before stronghold b.
Strongholds are numbered $0$ through $n - 1$.

*Output Format*

If a valid plan exists, output the lexicographically smallest one.

Otherwise, a bloody battle is inevitable — output \"QAQ\" (without quotes).

#block[
Who says you can only use a queue?

]
