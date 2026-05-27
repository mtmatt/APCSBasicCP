#import "../../template.typ": *

== IO Speed-Up
Since `scanf/printf` is not particularly convenient, and accelerated `cin/cout` is faster (when the input data is large), here is the method to speed up `cin/cout`.

#code(title: [IO Speed-Up])[
```cpp
int main() {
    ios::sync_with_stdio(0); cin.tie(0);
    // code here
}
```
]
