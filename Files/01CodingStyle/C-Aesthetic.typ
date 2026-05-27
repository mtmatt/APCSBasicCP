#import "../../template.typ": *

== Going Further
You can watch this video #link("https://www.youtube.com/watch?v=CFRhGnuXG-4")[https://www.youtube.com/watch?v=CFRhGnuXG-4]. The key takeaway is to avoid having too many levels of nesting.

=== Example: A five-level nesting example
#code(title: [An example with too many levels])[
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

The same code can be written like this, making it much easier to grasp what you are trying to express.

#code(title: [Improved version])[
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

In addition, we can try to follow another principle: each function should do only one thing and should not exceed 30 lines. This makes code much easier to read.
