#import "../../template.typ": *

== 常數優化
=== 編譯器優化
有時候可以突破複雜度限制，但不是萬能的。

==== 範例：一般版

#code(title: [一般版常數優化])[
```cpp
#pragma GCC optimize ("O3,unroll-loops")
```
]

==== 範例：強化版

#code(title: [強化版常數優化])[
```cpp
#pragma GCC optimize(3)
#pragma GCC optimize("Ofast")
#pragma GCC optimize("inline")
#pragma GCC optimize("-fgcse")
#pragma GCC optimize("-fgcse-lm")
#pragma GCC optimize("-fipa-sra")
#pragma GCC optimize("-ftree-pre")
#pragma GCC optimize("-ftree-vrp")
#pragma GCC optimize("-fpeephole2")
#pragma GCC optimize("-ffast-math")
#pragma GCC optimize("-fsched-spec")
#pragma GCC optimize("unroll-loops")
#pragma GCC optimize("-falign-jumps")
#pragma GCC optimize("-falign-loops")
#pragma GCC optimize("-falign-labels")
#pragma GCC optimize("-fdevirtualize")
#pragma GCC optimize("-fcaller-saves")
#pragma GCC optimize("-fcrossjumping")
#pragma GCC optimize("-fthread-jumps")
#pragma GCC optimize("-funroll-loops")
#pragma GCC optimize("-fwhole-program")
#pragma GCC optimize("-freorder-blocks")
#pragma GCC optimize("-fschedule-insns")
#pragma GCC optimize("inline-functions")
#pragma GCC optimize("-ftree-tail-merge")
#pragma GCC optimize("-fschedule-insns2")
#pragma GCC optimize("-fstrict-aliasing")
#pragma GCC optimize("-fstrict-overflow")
#pragma GCC optimize("-falign-functions")
#pragma GCC optimize("-fcse-skip-blocks")
#pragma GCC optimize("-fcse-follow-jumps")
#pragma GCC optimize("-fsched-interblock")
#pragma GCC optimize("-fpartial-inlining")
#pragma GCC optimize("no-stack-protector")
#pragma GCC optimize("-freorder-functions")
#pragma GCC optimize("-findirect-inlining")
#pragma GCC optimize("-fhoist-adjacent-loads")
#pragma GCC optimize("-frerun-cse-after-loop")
#pragma GCC optimize("inline-small-functions")
#pragma GCC optimize("-finline-small-functions")
#pragma GCC optimize("-ftree-switch-conversion")
#pragma GCC optimize("-foptimize-sibling-calls")
#pragma GCC optimize("-fexpensive-optimizations")
#pragma GCC optimize("-funsafe-loop-optimizations")
#pragma GCC optimize("inline-functions-called-once")
#pragma GCC optimize("-fdelete-null-pointer-checks")
```
]

#tip[
但通常與其花時間抄優化指令，不如想一個好的演算法。
]

=== 快讀快寫
可以改進輸入輸出的速度。對於數字規模約為 $10^6$ 的情況下，這個方法可以節省大約 $0.2$ 秒。

#code(title: [快速讀寫])[
```cpp
int in(){
    int rt=0,f=1;
    char ch=getchar();
    while(ch<'0' && ch>'9'){
        if(ch=='-')f=-1;
        ch=getchar();
    }
    while(ch>='0' && ch<='9'){
        rt=rt*10+ch-48;
        ch=getchar();
    }
    return rt*f;

}

void out(int x){
    if(x==0){putchar('0');return;}
    int len=0,num[20];
    while(x>0){
        num[++len]=x%10;
        x/=10;
    }
    for(;len>=1;--len){
        putchar(num[len]+48);
    }
    putchar('\n');
}
```
]
