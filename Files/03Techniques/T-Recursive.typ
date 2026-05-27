#import "../../template.typ": *

== Recursion
=== Definition First
Recursion is when a function calls itself, either directly or indirectly. That explanation isn't very clear, so here is a quote from *Wikipedia* as an illustration.

#quote(block: true)[
Once upon a time there was a mountain. In the mountain there was a temple. In the temple there was an old monk telling a story to a young monk. What was the story? "Once upon a time there was a mountain. In the mountain there was a temple. In the temple there was an old monk telling a story to a young monk. What was the story? 'Once upon a time there was a mountain. In the mountain there was a temple...'"
]

In practice, the recursive code is usually written inside another function. The following uses the most common second-order linear recurrence—the Fibonacci sequence—as an example.

#code(title: [Fibonacci Sequence Example])[
```cpp
int f(int n){
    if(n==1 || n==2){
        return 1;
    }
    return f(n-1)+f(n-2);
}
```
]

If you trace through this code with pencil and paper, you will see that $f(n)$ keeps calling $f(n-1)$ and $f(n-2)$. For example, $f(5)$ calls $f(4)$ and $f(3)$; $f(4)$ calls $f(3)$ and $f(2)$; $f(3)$ calls $f(2)$ and $f(1)$; $f(3)$ calls $f(2)$ and $f(1)$.

Note that "$f(3)$ calls $f(2)$ and $f(1)$" is intentionally repeated twice, because they are called by different instances of $f$.

You will likely notice that as $n$ grows larger, your program runs longer and longer. Around $n = 50$ or $60$, it becomes very slow. If you are sharp, you will also notice that your program seems to be repeating the same computations over and over. If you spot this, congratulations—you have just stepped into the deep pit of `DP`.

What?! You already know `DP`? Don't worry, there will be a dedicated chapter on `DP` later.

=== Practical Uses
In competitive programming, recursion is mainly used to grab partial scores. But do not underestimate it; it may turn out to be the key to your success.

In addition, many graph algorithms use recursion, especially `DFS`.

=== Brute-Force Recursion for Partial Scores

==== Example: Tic-Tac-Toe (2021 Eastern Region Simulation Contest)

*Problem Statement*

Doctor Strange wants to predict the future in order to change it. Although he knows the current state of many elements in the world, his magic is not yet powerful enough to compute all possibilities, so he decides to start training with the basic game of tic-tac-toe. Doctor Strange believes that if he can predict every possible outcome of tic-tac-toe, predicting the future won't be far off. Tic-tac-toe is a well-known two-player game with the following rules:

+ Given a 3 × 3 board, each cell is initially empty and can only be filled with one symbol.
+ Two players take turns placing their symbols ('o' and 'x') on the board.
+ When any player's three symbols form a horizontal, vertical, or diagonal line on the board, that player wins and the game ends.
+ If every cell has been filled, the game ends in a draw.


You are Maowu, Doctor Strange's top assistant—knowledgeable in all things and a top-notch Coder. Sometimes Doctor Strange feels uneasy about his predictions, so he asks you to help verify the answers.

Doctor Strange will give you the current state of a tic-tac-toe board. Assuming both players randomly and alternately fill in symbols, tell Doctor Strange: among all possible outcomes, how many times does 'o' win, how many times does 'x' win, and how many times does the game end in a draw?

*Input Format*

Input consists of 3 lines, each with 3 space-separated characters representing the current board state. '-' means the cell is empty; 'o' or 'x' means that player has already placed there. The input is guaranteed to have 'o' going first and the board state is valid.

*Output Format*

Output 1 line containing 3 integers: the number of times 'o' wins, the number of times 'x' wins, and the number of draws, separated by spaces.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`o - x`#linebreak()`x o o`#linebreak()`- o x`], [`1 0 1`],
  [Sample Input 2], [Sample Output 2],
  [`x o o`#linebreak()`- - -`#linebreak()`x x o`], [`2 1 2`],
)

The full-score solution to this problem is recursion—the idea is to search through all possible states. This explanation is not very clear, so let's elaborate. First, we fill in the empty cells one by one. We also know the game may end early. So we should check whether anyone has won before filling in each cell, then for each possible empty cell, recursively choose the next move, until the board is full.

#code(title: [Tic-Tac-Toe Solution])[
```cpp
// In the code below, check() determines who has won before each move.
// -1 means the game has not ended; 0 means 'o' wins; 1 means 'x' wins; 2 means draw.
//
// ttt is the main recursive function; the step variable tracks whose turn it is.

#include<bits/stdc++.h>
using namespace std;

char mp[5][5];
int ct[5];

// Check the board situation
int check(){
    for(int i=0;i<3;++i){
        // o-- | -o- | --o
        // o-- | -o- | --o
        // o-- | -o- | --o
        if(mp[i][0]==mp[i][1] && mp[i][1]==mp[i][2]){
            if(mp[i][0]=='o'){
                return 0;
            }else if(mp[i][0]=='x'){
                return 1;
            }
        }

        // ooo | --- | ---
        // --- | ooo | ---
        // --- | --- | ooo
        if(mp[0][i]==mp[1][i] && mp[1][i]==mp[2][i]){
            if(mp[0][i]=='o'){
                return 0;
            }else if(mp[0][i]=='x'){
                return 1;
            }
        }
    }

    // o--
    // -o-
    // --o
    if(mp[0][0]==mp[1][1] && mp[1][1]==mp[2][2]){
        if(mp[0][0]=='o'){
            return 0;
        }else if(mp[0][0]=='x'){
            return 1;
        }
    }

    // --o
    // -o-
    // o--
    if(mp[0][2]==mp[1][1] && mp[1][1]==mp[2][0]){
        if(mp[0][2]=='o'){
            return 0;
        }else if(mp[0][2]=='x'){
            return 1;
        }
    }

    // is tie?
    bool isfull=true;
    for(int i=0;i<3;++i){
        for(int j=0;j<3;++j){
            if(mp[i][j]=='-'){
                isfull=false;
            }
        }
    }

    if(isfull){
        return 2;
    }else{
        return -1;
    }
}

void ttt(int step){
    int ck=check();
    if(ck!=-1){
        ct[ck]++;
        return;
    }

    for(int i=0;i<3;++i){
        for(int k=0;k<3;++k){
            if(mp[i][k]=='-'){
                // On odd-numbered steps, the next player is 'x'
                if(step&1){
                    mp[i][k]='x';
                }else{
                    mp[i][k]='o';
                }

                ttt(step+1);
                mp[i][k]='-';
            }
        }
    }
}

int main(){
    ios::sync_with_stdio(0);cin.tie(0);

    int step=0;
    for(int i=0;i<3;++i){
        for(int j=0;j<3;++j){
            cin>>mp[i][j];
            if(mp[i][j]!='-') step++;
        }
    }

    ttt(step);
    for(int i=0;i<3;++i){
        cout<<ct[i]<<" ";
    }
    cout<<"\n";
}
```
]

=== Examples and Practice

==== Problem: Matchstick Equation

*Problem Statement*

Given $n$ matchsticks, how many equations of the form $A+B=C$ can you form? $A$, $B$, $C$ are integers formed by matchsticks (if the number is non-zero, the leading digit cannot be $0$). The matchstick representations of digits $0 tilde.op 9$ are shown in the figure:


#align(center)[#image("../Images/Recursive_Torch.png", width: 100%)]

+ The plus sign and equals sign each use $2$ matchsticks.
+ If $A != B$, then $A+B=C$ and $B+A=C$ are considered different equations. $A,B,C >= 0$
+ All matchsticks must be used.


*Input Format*

A single integer $n, 1 <= n <= 24$.

*Output Format*

A single integer representing the number of valid equations.

*Sample Tests*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`14`], [`2`],
  [Sample Input 2], [Sample Output 2],
  [`18`], [`9`],
)
