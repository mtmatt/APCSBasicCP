#import "../../template.typ": *

== 泛用標頭檔
你是否有為引入標頭檔而感到困擾呢？下方是一個較為極端的例子。

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

但其實這些都可以用以下一行取代，對於考試而言可以說方便許多。

#code(title: [泛用標頭檔])[
```cpp
#include<bits/stdc++.h>
```
]
