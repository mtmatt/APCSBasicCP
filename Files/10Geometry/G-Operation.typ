#import "../../template.typ": *

== 操作
=== 面積計算
我們可以使用行列式計算$v$與$u$所張成的平行四邊形面積，不過值得注意的是，
面積有方向。如果$v$順時針轉比較靠近$u$，那就是正的，否則就是負的。

$ a r e a \( v \, u \) = \( v_1 u_2 - v_2 u_1 \) $

#block[
#emph[證明。]
$ cos theta & = frac(sum_(i = 1)^n \( 2 times v_i times u_i \), 2 times \| v \| times \| u \|)\
 & = frac(v_1 u_1 + v_2 u_2, \| v \| times \| u \|)\
sin theta & = sqrt(1 - cos^2 theta)\
 & = frac(sqrt(\( \| v \| \| u \| \)^2 - \( v_1 u_1 + v_2 u_2 \)), \| v \| \| u \|)\
 & = frac(sqrt(\( v_1^2 + v_2^2 \) \( u_1^2 + u_2^2 \) - \( v_1 u_1 + v_2 u_2 \)^2), \| v \| \| u \|)\
 & = frac(v_1 u_2 - v_2 u_1, \| v \| \| u \|)\
a r e a \( v \, u \) & = \| v \| \| u \| sin theta\
 & = v_1 u_2 - v_2 u_1 $~◻

]
這樣的特性可以讓我們稍稍判斷兩個向量的相對方位。

實作上，我們會用外積(把$z$設為0)稱呼他。

==== Code: Area Calculation

```
T cross(const Pt a,const Pt b) { return a.x*b.y - a.y*b.x;}

int ori(const Pt a,const Pt b) {// positive negative zero
    T ret=cross(a,b);
    if(ret==0) return 0;
    return (ret<0)?-1:1;
}
```

=== 判斷點是否在直線上
我們可以藉由向量的運算得知。點$C$在直線$accent(A B, ⃡)$上
$arrow.l.r.double accent(A C, ⃗) = k accent(A B, ⃗) \, #h(0em) k in bb(R)$。

判斷$accent(A C, ⃗) = k accent(A B, ⃗)$是否成立的方法很簡單，因為兩個
向量平行，所以所圍出的面積為$0$。如此以來，
我們就可以用$c r o s s \( C - A \, B - A \) = 0$與否判斷。

=== 判斷點是否在線段上
我們可以藉由向量的運算得知。點$C$在線段$overline(A B)$上，
首先他必須在直線$accent(A B, ⃡)$上。接著，
$accent(C A, ⃗)$與$accent(C B, ⃗)$的夾角要是$180^compose$。

$ arrow.r.double.long accent(C A, ⃗) dot.op accent(C B, ⃗) < 0 $

=== 判斷線段是否相交
首先考慮這個情況，線段的端點在對方的線段中，那就算是相交了。

除此之外，那就有點困難了。
你可以解方程式之後判斷交點是否在兩個線段的範圍中。
不過這裡我們介紹另一個方法，假設兩線段分別是AB,CD。

$ upright("cross") \( accent(A B, ⃗) \, accent(A C, ⃗) \) times upright("cross") \( accent(A B, ⃗) \, accent(A D, ⃗) \) < 0\
upright("cross") \( accent(C D, ⃗) \, accent(C A, ⃗) \) times upright("cross") \( accent(C D, ⃗) \, accent(C B, ⃗) \) < 0 $

考慮cross正負發生的時機就可以知道其正確性。

=== 多邊形面積
考慮使用測量師公式。設多邊形頂點為$P_1 \, P_2 \, dots.h.c \, P_n$：

$ a r e a \( P \) = sum_(i = 1)^n accent(O P_i, ⃗) times accent(O P_(i + 1), ⃗) \, #h(0em) "define" #h(0em) n + 1 = 1 $

一個迴圈就搞定了。但是需要注意頂點必須要順時針或逆時針排序，所以以下來介紹怎麼做。

=== 極角排序
就是讓頂點順時針或逆時針排序，所以以下來介紹怎麼做。

首先，三角函數的
常數極大，因為用泰勒展開式等實作，所以以下方式雖然可以使用，但是很慢。

==== Code: Polar Angle Sort with Inverse Trig

```
bool cmp(Pt a,Pt b){
    return atan2(a.x,a,y)<atan2(b.x,b.y);
}
```

另一個方式是可以使用外積與座標平面特性，因為外積的適用範圍只有$180^compose$，
所以我們必須拆開上下(或左右)半平面。

==== Code: Polar Angle Sort with Cross Product

```
bool cmp(Pt a,Pt b){
    bool f1=a.x<0 || (a.x==0 && a.y<0);
    bool f2=b.x<0 || (b.x==0 && b.y<0);
    if(f1!=f2) return f1<f2;
    return cross(a,b)>0;
}
```

=== 凸包
給你一堆點，問你可以包住這些所有點的最小凸多邊形。

這樣的多邊形一定可以藉由對x,y做字典順序，並嘗試
一個一個加入點。

如果角度超過$180^compose$，就把裡面的點拿出來。

這樣的操作做兩次，一次從$1 arrow.r n$，另一次從$n arrow.r 1$。

判斷角度超過$180^compose$，若
$upright("cross") \( accent(A B, ⃗) \, accent(B C, ⃗) \) lt.eq 0$
則 $B$ 不在凸包上。

==== Code: Convex Hull

```
vector<Pt> ConvexHull(vector<Pt> ds){
    sort(ds.begin(),ds.end(),CmpByXY);

    vector<Pt> ret;
    int k=0;
    for(auto i:ds){
        while(k>=2 && ori(ret[k-1]-ret[k-2],i-ret[k-1])<=0) {
            ret.pop_back();
            k--;
        }

        ret.emplace_back(i);
        k++;
    }

    ret.pop_back();
    k--;

    reverse(ds.begin(),ds.end());

    int hf=k;
    for(auto i:ds){
        while(k-hf>=2 && ori(ret[k-1]-ret[k-2],i-ret[k-1])<=0) {
            ret.pop_back();
            k--;
        }

        ret.emplace_back(i);
        k++;
    }
    ret.pop_back();// not count right element twice
    return ret;
}
```

凸包可以應用在求最遠點對，因為如果值域的範圍是$C$，
那凸包上最多會有$sqrt(C)$個點。枚舉所有點對的複雜度為
$O \( C \)$。

另外DP優化也有可能會用到。

=== 其他資源

#link("https://hackmd.io/@Ccucumber12/BJeOhtzbF#/")

#box(image("../Images/Vector1.png", width: 20.0%))
