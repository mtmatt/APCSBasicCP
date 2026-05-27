#import "../../template.typ": *

== Universal Header File
Have you ever found including header files to be a hassle? Below is a rather extreme example.

#code(title: [Code])[
```cpp
#include<iostream>
#include<fstream>
#include<conio.h>
#include<sstream>

#include<string>
#include<vector>
#include<stack>
#include<queue>
#include<deque>
#include<set>
#include<map>
#include<bitset>

#include<algorithm>
#include<cstdlib>
#include<cmath>
#include<ctime>
```
]

All of the above can actually be replaced with the single line below, which is incredibly convenient for contests.

#code(title: [Universal Header File])[
```cpp
#include<bits/stdc++.h>
```
]
