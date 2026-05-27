#import "../../template.typ": *

== 樹狀數組
樹狀數組又稱為BIT，是個快速動態求取區間和的助手。

=== 回顧
還記得前綴和嗎，他也是用來求區間和的，但你應該會發現，若當中有一個值需要被修改，那整列都會被動到，因此複雜度就會增加。

以下是一個比較表，可以讓你了解BIT的強大之處。

#table(columns: 3, stroke: .5pt, inset: 5pt,
  [資料結構],
  [查詢區間和],
  [單點修改值],
  [純陣列],
  [$O(n)$],
  [$O(1)$],
  [前綴和],
  [$O(1)$],
  [$O(n)$],
  [BIT],
  [$O(log(n))$],
  [$O(log(n))$],
)

=== 用途與概念
BIT用於在快速求取區間和的同時，又能保證快速修改。感覺像是陣列與前綴和的優點結合下的產物，不過其複雜程度也是三者之中最高的。示意圖中數字代表它儲存的區間。

#align(center)[#image("../Images/BIT.png", width: 100%)]
#align(center)[_BIT 示意圖_]

如果想要知道`1-5`的和，可以查詢`1-4+5`。以下為查詢所需區間表。

#table(columns: 8, stroke: .5pt, inset: 5pt,
  [1],
  [1--2],
  [1--3],
  [1--4],
  [1--5],
  [1--6],
  [1--7],
  [1--8],
  [1],
  [1--2],
  [1--2 & 3],
  [1--4],
  [1--4 & 5],
  [1--4 & 5--6],
  [1--4 & 5--6 & 7],
  [1--8],
)

可以發現，在元素數量為$8$時，最多會需要查詢$3$個區間就可以得到`1-n`的值，接著就像前綴和那樣，用`1~R - 1~(L-1)`就可以求出所有區間的和了。

=== 實作
BIT一般都是用陣列實作，用區間最大值作為存放位置(例如`1-4`放在`4`)。那搜尋與修改呢？這部分就比較複雜了，需要了解一些二進位制，如果你已經理解二進位制了，那就繼續往下看吧。

*lowbit*

lowbit是在二進位下右邊看過來最前面的1，例如：6(000110)就是2(000010)

*查詢*

可以發現，$x$重複$-"lowbit"(x)$會變成0，且途中會經過所有需要的區間。以7為例。

```text
7(000111) \to 6(000110) \to 4(000100 \to 0(000000))
```

只要將所有經過的區間加在一起，就可以得到區間和了。這也呼應為何他查尋的複雜度為$O(log(n))$，因為$n$最多只會有$log(n)$個 bit。

*修改*

修改也有些相似，變成$x$加上$"lowbit"(x)$，就會將上面有包含到他的區間也都更新到。以$3$為例。

```text
3(000011) \to 4(000100) \to 8(001000)
```

因為每一次都會進位，所以這樣最多也是$O(log(n))$。也可以發現`lowbit`的重要性。

*程式碼*

#code(title: [BIT])[
```cpp
#define "lowbit"(x) (x&-x)
// equivalent to: int lowbit(int x){ return x&-x;}
// Using a define or function won't make your code faster to write,
// but it makes it easier to understand.

using ll=long long;

ll bt[200010];
ll a[200010];

// The build function constructs the BIT by updating all elements one by one
void build(int n){
    for(int i=1;i<=n;++i)
        for(int x=i;x<200005;x+="lowbit"(x))
            bt[x]+=a[i];
}

// Point add
void add(int x,int k){
    a[x]+=k;
    for(int i=x;i<=200005;i+="lowbit"(i))
        bt[i]+=k;
}

// Point set, derived from point add
void modify(int x,int k){
    add(x,k-a[i]);
}

// Query the prefix sum from 1 to x
ll find_sum(int x){
    ll ret=0;
    for(int i=x;i>0;i-="lowbit"(i))
        ret+=bt[i];
    return ret;
}

// Compute any range sum using (1 to r) - (1 to l-1)
ll query(int l,int r){
    return find_sum(r)-find_sum(l-1);
}
```
]

=== 範例與練習
==== Problem: ZJ d796 區域調查(POJ.1195 Mobile phones 改編)

*題目敘述*

給一個矩陣 $T(1,1), T(1,2),.... T(N,M)$，求 $T(x_1,y_1)$  到 $T(x_2,y_2)$ 的總和 或者是修改 $T(x_1,y_1)$ 的值。

*輸入說明*

每組輸入的第一行會有兩個正整數 $N \; Q$ $( 1 <= N <= 250,  Q <= 5 times 10^5)$。

接下來會有 $N$ 行，每行上會有 $N$ 個元素 $M$ $( 0 <= M <= 32767 )$。

接下來會有 $Q$ 行，倘若第一個數字為$1$，則接下來會有四個數字：

$x_1 , y_1 , x_2 , y_2， 1 <= x_1 , y_1 , x_2 , y_2 <= 250$

請輸出元素 $S={( x , y )   |   x_1 <= x <= x_2, y_1 <= y <= y_2 }$符合的所有元素總和。

倘若第一個數字為$2$，則接下來會有三個數字：

$x_1 , y_1 , V， 1 <= x_1 , y_1 <= 250 , 0 <= V <= 32767$

請修改 $( x_1 , y_1 )= V$ ，此行不必輸出。

*輸出說明*

若為調查，則輸出區域中的元素總和，若為修改，則不必輸出。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5 10`#linebreak()`3 2 2 3 7`#linebreak()`4 4 0 3 8`#linebreak()`2 4 7 2 3`#linebreak()`5 9 6 1 4`#linebreak()`7 1 7 1 1`#linebreak()`2 2 2 1`#linebreak()`1 5 4 5 5`#linebreak()`2 2 1 7`#linebreak()`1 3 2 1 5`#linebreak()`1 2 5 4 5`#linebreak()`1 1 2 2 1`#linebreak()`2 2 2 7`#linebreak()`2 4 5 5`#linebreak()`1 3 3 4 5`#linebreak()`1 4 3 2 2`], [`2`#linebreak()`42`#linebreak()`15`#linebreak()`13`#linebreak()`24`#linebreak()`33`],
)

#tip[
BIT同樣可以做成二維。
]

==== Problem: ZJ d847 98學年度中投區資訊學科能力競賽 2D rank finding problem

*題目敘述*

二度空間上的排名計算問題(2D rank finding problem)：給定二度平面空間$(2D)$上的點$A = (a_1,a_2)$與點$B = (b_1,b_2)$，其大小關係定義為若$A > B$若且唯若 $a_1 > b_1$ 且 $a_2 > b_2$，亦即A點在B點的右上方。值得注意的是，並非任意兩點均可以決定大小關係，如下圖中的點A與點E，點D與點E等，無法決定這兩點的大小關係故為無法比較(incomparable)。給定N個點$(x_1,y_1), (x_2,y_2), dots.c, (x_n,y_n)$，定義某一個點的排名(rank) 為所給的點集合中，比該點小的點的個數。

設計一個程式，從檔案讀取點的名稱與座標，計算出在所給定的集合中，所有點的排名值。

*輸入說明*

有多組測試資料。

每組的第一行有一個數字$N \; ( 1 <= N <= 10000 )$。

接下來會有$N$行，每行上會有兩個數字  $x, \; y \; ( 1 <= x , y <= 1000 )$。

*輸出說明*

請按照輸入的順序，求出對於 $( x , y )$ 有多少個點 $( a , b )$ 在它的左下方 $a < x , b < y$。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`961 404`#linebreak()`640 145`#linebreak()`983 888`#linebreak()`539 71`#linebreak()`437 532`], [`2`#linebreak()`1`#linebreak()`4`#linebreak()`0`#linebreak()`0`],
)

==== Problem: 低地距離(2020年10月APCS)

*題目敘述*

輸入一個長度為 $2n$ 的陣列，其中 $1 - n$ 的每個數字都剛好各 $2$ 次。

$i$ 的低窪值的定義是兩個數值為 $i$ 的位置中間，有幾個小於 $i$ 的數字。

以 $[3, 1, 2, 1, 3, 2]$ 為例，$1$的低窪值為 $0, 2$ 的低窪值為 $1, 3$ 的低窪值為 $3$。

請對於每個 $1 - n$ 的數字都求其低窪值（兩個相同的數字之間有幾個數字比它小），輸出低窪值的總和，答案可能會超過 $C++$ `int` 的上限。

*輸入說明*

第一行有一個正整數 $n, \; n <= 10^5$。

第二行有 $2n$ 個正整數，以空格分隔，保證 $1 - n$ 每個數字都恰好出現兩次。

*輸出說明*

輸出 $1 - n$ 每個數字的低窪值總和。

*範例測試*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3`#linebreak()`3 1 2 1 3 2`], [`4`],
)
