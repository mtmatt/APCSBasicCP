#import "../../template.typ": *

== Constant-Factor Optimization
=== Compiler Optimization
Can sometimes break through complexity limits, but is not a silver bullet.

==== Example: Standard Version

#code(title: [Standard Constant-Factor Optimization])[
```cpp
#pragma GCC optimize ("O3,unroll-loops")
```
]

==== Example: Reinforced Version

#code(title: [Reinforced Constant-Factor Optimization])[
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
Usually, instead of spending time copying optimization pragmas, it is better to think of a good algorithm.
]

=== Fast Read/Write
Can improve input/output speed. For data on the order of $10^6$ numbers, this method can save approximately $0.2$ seconds.

#code(title: [Fast Read/Write])[
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
