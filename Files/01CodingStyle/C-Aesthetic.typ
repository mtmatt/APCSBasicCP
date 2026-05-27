#import "../../template.typ": *

== 更進一步
可以去看這一部影片 #link("https://www.youtube.com/watch?v=CFRhGnuXG-4")[https://www.youtube.com/watch?v=CFRhGnuXG-4] ，重點是不要有太多層的迴圈。

=== 範例：五層的範例
#code(title: [太多層的例子])[
```cpp
bool check(int a,int b){
    if(a+b>100){
        if(a-b<50){
            for(int i=1;i<a;i*=2;++i){
                if(a*i%1000==200){
                    for(int j=0;j<a+b;++j){
                        a=(a+b)%100;
                        b=(a-b)%100;
                    }
                }
                return a%2;
            }
        }else{
            return a%2;
        }
    }else{
        return b%2;
    }
}
```
]

同樣的程式碼可以寫成這樣，會比較容易掌握你要表達的意義。

#code(title: [改進的版本])[
```cpp
void modify(int &a,int &b){
    for(int j=0;j<a+b;++j){
        a=(a+b)%100;
        b=(a-b)%100;
    }
}

bool check(int a,int b){
    if(a+b<=100){
        return b%2;
    }

    if(a-b>=50){
        return a%2;
    }

    for(int i=1;i<a;i*=2;++i){
        if(a*i%1000==200){
            modify(a,b);
            return a%2;
        }
    }
}
```
]

除此之外，我們也可以嘗試遵守一個原則，就是一個函數只做一件事情，並且不要超過30行，這樣會讓程式碼更容易閱讀。
