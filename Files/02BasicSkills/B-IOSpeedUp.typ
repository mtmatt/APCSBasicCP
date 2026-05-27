#import "../../template.typ": *

== IO加速
由於 `scanf/printf` 並不是特別好用，而且經過加速後的 `cin/cout` 會比較快(在輸入測資較大時)。於是附上 `cin/cout` 的加速方法。

#code(title: [IO加速])[
```cpp
int main() {
    ios::sync_with_stdio(0); cin.tie(0);
    // code here
}
```
]
