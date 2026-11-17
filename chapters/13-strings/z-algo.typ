#import "../../template.typ": *

在 KMP 中，我們預處理的方式是找出最長的重複前後綴，這樣在匹配失敗時可以跳過一些不必要的比較。

除了重複的前後綴以外，我們也可以使用 #strong[最長公共前綴（LCP, Longest Common Prefix）] 的資訊來優化字串處理流程。這樣的想法即是 #strong[擴展KMP]（又稱 Z-Algorithm）背後的核心思想。

=== Z-陣列定義

給定一個字串 $S$，我們定義 Z-陣列 $Z [i]$ 表示：

$ Z [i] = max {k divides S [0 dots.h k - 1] = S [i dots.h i + k - 1]} $

換句話說，$Z [i]$ 是從位置 $i$ 開始的字串與整個字串開頭（$S [0 dots.h]$）的最長公共前綴長度。

舉例而言，設字串 $S = mono("ababc")$ 且 $i = 2$，則 $Z [2] = 2$，因為從位置 $2$ 開始的字串 $mono("abc")$ 與整個字串 $mono("ababc")$ 的最長公共前綴長度為 $2 (mono("ab"))$。

舉一個比較長的例子，對字串 $S = mono("aabcaabxaaaz")$，我們有：

#align(center, table(
  columns: 2,
  align: (center, center,),
  table.header([$i$], [$Z [i]$]),
  [0], [-（不定義或取整體長度）],
  [1], [1],
  [2], [0],
  [3], [0],
  [4], [3],
  [5], [1],
  [6], [0],
  [7], [0],
  [8], [2],
  [9], [2],
  [10], [1],
  [11], [0],
))

=== Z-陣列的構造

我們可以在 $O(n)$ 的時間內構造整個 $Z$ 陣列，透過維護一個目前可延伸的區間 $[L, R]$，代表目前為止右端延伸最遠的 prefix 相等區段。

#listing([建構Z陣列的 C++ 實作])[
```cpp
vector<int> Z_Function(const string& S) {
    int n=S.size();
    vector<int> Z(n, 0);
    int L=0, R=0;

    for (int i=1;i<n;i++){
        if(i<=R)
            Z[i]=min(R-i+1, Z[i-L]);

        while(i+Z[i]<n && S[Z[i]]==S[i+Z[i]])
            Z[i]++;

        if(i+Z[i]-1>R){
            L=i;
            R=i+Z[i]-1;
        }
    }

    return Z;
}
```
]

當 $i > R$，我們只能從頭一個一個比對；但如果 $i lt.eq R$，我們可以利用對稱性嘗試從 $Z [i - L]$ 的資訊推進。

=== Z-陣列的應用

Z 陣列的核心優勢是可以快速回答以下問題：

- 一個 pattern 是否出現在 text 中

- 所有位置的最長公共前綴長度

- 判斷字串是否具有週期性（最短 border）

- 對於 $S = P + mono("$") + T$，只要找到 $Z [i] = |P|$ 的位置，即可得知 pattern $P$ 在 text $T$ 中出現的位置

=== 與 KMP 的比較

Z 陣列與 KMP prefix function 本質上都處理字串的重複結構，但：

- KMP 的 prefix function 關心的是 $S [0 dots.h i]$ 中的最大前綴等於後綴的長度

- Z 陣列則關心每個 $i$ 開頭與整體字串最長前綴的匹配程度

- KMP 適合用在動態比對中（遇到 mismatch 立即跳轉）

- Z 陣列更適合整體前綴匹配分析與 pattern + text 一次合併處理

=== 總結

Z 陣列提供了另一種觀察字串內部結構的方式，其應用面向廣泛，特別適合與 pattern matching、週期性判斷、最長公共前綴等問題結合使用。
