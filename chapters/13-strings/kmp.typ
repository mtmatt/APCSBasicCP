#import "../../template.typ": *

== KMP 字串搜尋演算法

KMP 演算法的關鍵在於：當匹配失敗時，我們不需要將模式串 $P$ 完全回溯到起始位置，而是可以利用已經匹配成功的字元資訊，將 $P$ 向右「跳躍」一定的距離。這個「跳躍」的距離是由模式串 $P$ 自身的結構決定的。

KMP 演算法的核心是構建一個 #strong[「部分匹配表」（Partial Match Table, PMT）]，也稱為 #strong[「失配函數」（Failure Function）] 或 #strong[「前綴函數」（Prefix Function）]。這個表紀錄了模式串 $P$ 中每個前綴的最長「共同前後綴」的長度。

=== 「共同前後綴」的概念

對於一個字串 $S$，它的#strong[前綴]是指從字串開頭到任意位置的子字串，例如 `ABC` 的前綴有 `A`, `AB`, `ABC`。它的#strong[後綴]是指從任意位置到字串結尾的子字串，例如 `ABC` 的後綴有 `C`, `BC`, `ABC`。

#strong[共同前後綴]：一個字串 $S$ 的一個前綴同時也是 $S$ 的一個後綴。例如，對於字串 $S = "ABCAB"$：

- 前綴：`A`, `AB`, `ABC`, `ABCA`, `ABCAB`

- 後綴：`B`, `AB`, `CAB`, `BCAB`, `ABCAB`

其共同前後綴有 `AB`。最長共同前後綴的長度是 2。

=== 部分匹配表（PMT）的定義

#strong[PMT\[i\]] 表示模式串 $P$ 的長度為 $i + 1$ 的前綴 $P [0 dots.h i]$ 中，最長的#strong[真共同前後綴]（即不等於前綴本身的共同前後綴）的長度。

例如，對於模式串 $P = "ABCAB"$：

- `P[0...0]` (`A`): 最長真共同前後綴長度為 0。PMT\[0\] = 0。

- `P[0...1]` (`AB`): 最長真共同前後綴長度為 0。PMT\[1\] = 0。

- `P[0...2]` (`ABC`): 最長真共同前後綴長度為 0。PMT\[2\] = 0。

- `P[0...3]` (`ABCA`): 最長真共同前後綴為 `A`，長度為 1。PMT\[3\] = 1。

- `P[0...4]` (`ABCAB`): 最長真共同前後綴為 `AB`，長度為 2。PMT\[4\] = 2。

所以，PMT 表為 `[0, 0, 0, 1, 2]`。

通常，我們使用的 PMT 陣列會根據索引調整，使得 $"PMT" [k]$ 對應的是長度為 $k$ 的前綴的最長共同前後綴的長度。此時 PMT 的大小為 $m$， $"PMT" [0]$ 沒有實際意義或定義為 -1。在 C++ 實作中，我們通常稱其為 #strong[lps] (longest proper prefix suffix) 陣列，且 `lps[i]` 表示 $P [0 dots.h i - 1]$ 這個長度為 $i$ 的前綴的最長共同前後綴的長度。

例如，對於模式串 $P = "ABABCABAB"$ (長度 $m = 9$)

#align(center, table(
  columns: 4,
  align: (center, center, center, center,),
  table.header([$i$], [$P [0 dots.h i - 1]$ (前綴)], [最長真共同前後綴], [`lps[i]`]),
  [0], [(空字串)], [], [0 (或 -1)],
  [1], [`A`], [], [0],
  [2], [`AB`], [], [0],
  [3], [`ABA`], [`A`], [1],
  [4], [`ABAB`], [`AB`], [2],
  [5], [`ABABC`], [], [0],
  [6], [`ABABCA`], [`A`], [1],
  [7], [`ABCABA`], [`A`], [1],
  [8], [`ABCABAB`], [`AB`], [2],
  [9], [`ABCABABA`], [`ABA`], [3],
))

實際應用中，為了簡化邏輯，`lps[i]` 通常表示的是模式串 $P$ 的#strong[長度為 $i$ 的前綴]（即 $P [0 dots.h i - 1]$）的最長共同前後綴的長度。對於 `P[0]` (長度為 1 的前綴)，`lps[1]` = 0。

=== 構建部分匹配表（PMT \/ `lps` 陣列）

構建 `lps` 陣列是 KMP 演算法的關鍵一步。這個過程本身就可以看作是一個簡化的 KMP 演算法。

我們使用兩個指標：

- `len`: 表示當前正在考慮的前綴的最長共同前後綴的長度。

- `i`: 遍歷模式串的當前字元索引。

初始化：`lps[0] = 0` (對於 `P[0]`，沒有真共同前後綴)，`len = 0`，`i = 1`。

迭代過程：對於 `i` 從 1 到 $m - 1$（$m$ 是模式串長度）：

+ 如果 `P[i] == P[len]`：這表示當前字元與長度為 `len` 的前綴的下一個字元匹配。那麼最長共同前後綴的長度可以增加。 `len++`；`lps[i] = len`；`i++`。

+ 如果 `P[i] != P[len]`：這表示不匹配。我們需要尋找一個更短的共同前後綴。

  - 如果 `len != 0`：我們不能簡單地將 `len` 設為 0，而是需要根據 `lps[len-1]` 的值，回溯到前一個最長共同前後綴的長度。這樣做是因為 `lps[len-1]` 儲存了 `P[0...len-1]` 這個前綴的最長共同前後綴的長度，相當於在 `P[0...len-1]` 中尋找下一個可能的匹配起點。 `len = lps[len-1]`。

  - 如果 `len == 0`：這表示已經回溯到最開頭，沒有更短的共同前後綴了。那麼 `P[0...i]` 的最長共同前後綴長度就是 0。 `lps[i] = 0`；`i++`。

==== 構建 `lps` 陣列的範例

模式串 $P = "AAACAAAAAC"$ ($m = 10$) 初始化：`lps` 陣列大小為 10，`len = 0`，`i = 1`。

+ `i = 1`, `P[1] = 'A'`, `P[len] = P[0] = 'A'` `P[1] == P[0]`。 `len` 變為 1。`lps[1] = 1`。`i` 變為 2。 `lps = [0, 1, ?, ?, ?, ?, ?, ?, ?, ?]`

+ `i = 2`, `P[2] = 'A'`, `P[len] = P[1] = 'A'` `P[2] == P[1]`。 `len` 變為 2。`lps[2] = 2`。`i` 變為 3。 `lps = [0, 1, 2, ?, ?, ?, ?, ?, ?, ?]`

+ `i = 3`, `P[3] = 'C'`, `P[len] = P[2] = 'A'` `P[3] != P[2]`。 `len != 0` (len=2)。所以 `len = lps[len-1] = lps[1] = 1`。 `lps = [0, 1, 2, ?, ?, ?, ?, ?, ?, ?]` (len 變回 1)

+ `i = 3`, `P[3] = 'C'`, `P[len] = P[1] = 'A'` `P[3] != P[1]`。 `len != 0` (len=1)。所以 `len = lps[len-1] = lps[0] = 0`。 `lps = [0, 1, 2, ?, ?, ?, ?, ?, ?, ?]` (len 變回 0)

+ `i = 3`, `P[3] = 'C'`, `P[len] = P[0]` (len=0，這表示比較 `P[3]` 和 `P[0]`) `P[3] != P[0]`。 `len == 0`。 `lps[3] = 0`。`i` 變為 4。 `lps = [0, 1, 2, 0, ?, ?, ?, ?, ?, ?]`

+ `i = 4`, `P[4] = 'A'`, `P[len] = P[0] = 'A'` `P[4] == P[0]`。 `len` 變為 1。`lps[4] = 1`。`i` 變為 5。 `lps = [0, 1, 2, 0, 1, ?, ?, ?, ?, ?]`

+ `i = 5`, `P[5] = 'A'`, `P[len] = P[1] = 'A'` `P[5] == P[1]`。 `len` 變為 2。`lps[5] = 2`。`i` 變為 6。 `lps = [0, 1, 2, 0, 1, 2, ?, ?, ?, ?]`

+ `i = 6`, `P[6] = 'A'`, `P[len] = P[2] = 'A'` `P[6] == P[2]`。 `len` 變為 3。`lps[6] = 3`。`i` 變為 7。 `lps = [0, 1, 2, 0, 1, 2, 3, ?, ?, ?]`

+ `i = 7`, `P[7] = 'A'`, `P[len] = P[3] = 'C'` `P[7] != P[3]`。 `len != 0` (len=3)。所以 `len = lps[len-1] = lps[2] = 2`。 `lps = [0, 1, 2, 0, 1, 2, 3, ?, ?, ?]` (len 變回 2)

+ `i = 7`, `P[7] = 'A'`, `P[len] = P[2] = 'A'` `P[7] == P[2]`。 `len` 變為 3。`lps[7] = 3`。`i` 變為 8。 `lps = [0, 1, 2, 0, 1, 2, 3, 3, ?, ?]`

+ `i = 8`, `P[8] = 'A'`, `P[len] = P[3] = 'C'` `P[8] != P[3]`。 `len != 0` (len=3)。所以 `len = lps[len-1] = lps[2] = 2`。 `lps = [0, 1, 2, 0, 1, 2, 3, 3, ?, ?]` (len 變回 2)

+ `i = 8`, `P[8] = 'A'`, `P[len] = P[2] = 'A'` `P[8] == P[2]`。 `len` 變為 3。`lps[8] = 3`。`i` 變為 9。 `lps = [0, 1, 2, 0, 1, 2, 3, 3, 3, ?]`

+ `i = 9`, `P[9] = 'C'`, `P[len] = P[3] = 'C'` `P[9] == P[3]`。 `len` 變為 4。`lps[9] = 4`。`i` 變為 10 (結束)。 `lps = [0, 1, 2, 0, 1, 2, 3, 3, 3, 4]`

最終 `lps` 陣列為 `[0, 1, 2, 0, 1, 2, 3, 3, 3, 4]`。

=== KMP 演算法匹配過程

有了 `lps` 陣列後，KMP 的匹配過程就變得高效。

我們使用兩個指標：

- `i`: 指向文本串 $T$ 的當前字元索引。

- `j`: 指向模式串 $P$ 的當前字元索引。

初始化：`i = 0`，`j = 0`。

迭代過程：當 `i < n` 且 `j < m` ($n$ 是文本長度，$m$ 是模式串長度)：

+ 如果 `P[j] == T[i]`：這表示匹配成功。繼續比較下一個字元。 `i++`；`j++`。

+ 如果 `P[j] != T[i]`：這表示匹配失敗。

  - 如果 `j != 0`：我們不需要回溯文本串 $T$ 的 `i`，而是利用 `lps` 陣列將模式串 $P$ 向右「跳躍」。新的 `j` 值將是 `lps[j-1]`。這表示我們將模式串的 `P[0...j-1]` 這個前綴的最長共同前後綴對齊到 $T$ 的當前匹配位置。 `j = lps[j-1]`。

  - 如果 `j == 0`：這表示模式串的第一個字元就沒有匹配成功。我們只能將文本串 $T$ 的指針向右移動一位，模式串 $P$ 的指針依然保持在 0。 `i++`。

匹配成功判斷：如果 `j == m`，表示模式串 $P$ 已經在文本串 $T$ 中找到了一個匹配。此時匹配的起始位置是 `i - m`。找到一個匹配後，為了尋找下一個匹配，我們需要將 `j` 重置為 `lps[j-1]`，繼續從當前 $T$ 的位置尋找。

==== KMP 匹配範例

文本 $T = "ABABCABABABABABCABAB"$ 模式串 $P = "ABCABAB"$ 其 `lps` 陣列為 `[0, 0, 0, 1, 2, 3, 4]`

初始化：`i = 0`, `j = 0`

+ `T[0]='A'`, `P[0]='A'` $arrow.r$ 匹配。`i=1, j=1`

+ `T[1]='B'`, `P[1]='B'` $arrow.r$ 匹配。`i=2, j=2`

+ `T[2]='A'`, `P[2]='C'` $arrow.r$ 不匹配。 `j != 0` (j=2)。`j = lps[j-1] = lps[1] = 0`。此時 $T$ 指針 `i` 不變，仍為 2。模式串 $P$ 移位，從 `P[0]` 重新與 `T[2]` 比較。 `i=2, j=0`

+ `T[2]='A'`, `P[0]='A'` $arrow.r$ 匹配。`i=3, j=1`

+ `T[3]='B'`, `P[1]='B'` $arrow.r$ 匹配。`i=4, j=2`

+ `T[4]='C'`, `P[2]='C'` $arrow.r$ 匹配。`i=5, j=3`

+ `T[5]='A'`, `P[3]='A'` $arrow.r$ 匹配。`i=6, j=4`

+ `T[6]='B'`, `P[4]='B'` $arrow.r$ 匹配。`i=7, j=5`

+ `T[7]='A'`, `P[5]='A'` $arrow.r$ 匹配。`i=8, j=6`

+ `T[8]='B'`, `P[6]='B'` $arrow.r$ 匹配。`i=9, j=7` 此時 `j == m` (j=7, m=7)。找到一個匹配！匹配起始位置為 `i - m = 9 - 7 = 2`。為了尋找下一個匹配，`j = lps[j-1] = lps[6] = 4`。 `i=9, j=4` (繼續比較 `T[9]` 和 `P[4]`)

+ `T[9]='A'`, `P[4]='B'` $arrow.r$ 不匹配。 `j != 0` (j=4)。`j = lps[j-1] = lps[3] = 1`。 `i=9, j=1`

+ `T[9]='A'`, `P[1]='B'` $arrow.r$ 不匹配。 `j != 0` (j=1)。`j = lps[j-1] = lps[0] = 0`。 `i=9, j=0`

+ `T[9]='A'`, `P[0]='A'` $arrow.r$ 匹配。`i=10, j=1` ... 繼續匹配直到文本結束。

=== 時間複雜度分析

- #strong[構建 lps 陣列：] 兩個指針 `i` 和 `len` 都單向遞增，並且 `len` 在每次不匹配時會通過 `lps[len-1]` 縮短，但總的縮短次數不會超過 `len` 的總增長次數。因此，構建 `lps` 陣列的時間複雜度是 $O(m)$，其中 $m$ 是模式串的長度。

- #strong[KMP 匹配過程：] 類似地，文本指針 `i` 和模式串指針 `j` 都單向遞增。當不匹配時，`j` 會通過 `lps[j-1]` 縮短，但總的縮短次數不會超過 `j` 的總增長次數。因此，KMP 匹配過程的時間複雜度是 $O(n)$，其中 $n$ 是文本的長度。

- #strong[總體時間複雜度：] $O(m + n)$。

- #strong[空間複雜度：] $O(m)$，用於儲存 `lps` 陣列。

相較於樸素演算法的 $O(m times n)$ 最差時間複雜度，KMP 演算法在效率上有了顯著提升。

=== C++ 實作

#listing([KMP 演算法的 C++ 實作])[
```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> computeLPSArray(const string& pat) {
    int m = pat.length();
    vector<int> lps(m, 0);
    int length = 0;
    int i = 1;

    // Loop calculates lps[i] for i = 1 to m-1
    while (i < m) {
        if (pat[i] == pat[length]) {
            length++;
            lps[i] = length;
            i++;
        } else { // (pat[i] != pat[length])
            if (length != 0) {
                length = lps[length - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
    return lps;
}

void KMPSearch(const string& txt, const string& pat) {
    int n = txt.length();
    int m = pat.length();

    if (m == 0) {
        cout << "Pattern is empty. Found at every position." << endl;
        return;
    }
    if (n == 0) {
        cout << "Text is empty. No pattern found." << endl;
        return;
    }
    if (m > n) {
        cout << "Pattern length is greater" << endl;
        return;
    }

    vector<int> lps = computeLPSArray(pat);

    cout << "LPS array for pattern \"" << pat << "\": [";
    for (int k = 0; k < m; ++k) {
        cout << lps[k] << (k == m - 1 ? "" : ", ");
    }
    cout << "]" << endl;

    int i = 0, j = 0;
    int count = 0;

    while (i < n) {
        if (pat[j] == txt[i]) {
            i++;
            j++;
        }

        if (j == m) {
            cout << "Found pattern at index " << i - j << endl;
            count++;
            j = lps[j - 1];
        } else if (i < n && pat[j] != txt[i]) {
            if (j != 0) {
                j = lps[j - 1];
            } else {
                i++;
            }
        }
    }

    if (count == 0) {
        cout << "No pattern found in the text." << endl;
    }
}

int main() {
    string text1 = "ABABDABACDABABCABAB";
    string pattern1 = "ABABCABAB";
    cout << "Text: \"" << text1 << "\"" << endl;
    cout << "Pattern: \"" << pattern1 << "\"" << endl;
    KMPSearch(text1, pattern1);

    string text2 = "AAAAABAAABAA";
    string pattern2 = "AAAB";
    cout << "Text: \"" << text2 << "\"" << endl;
    cout << "Pattern: \"" << pattern2 << "\"" << endl;
    KMPSearch(text2, pattern2);

    string text3 = "ABCDEFGH";
    string pattern3 = "XYZ";
    cout << "Text: \"" << text3 << "\"" << endl;
    cout << "Pattern: \"" << pattern3 << "\"" << endl;
    KMPSearch(text3, pattern3);

    string text4 = "ABABABABC";
    string pattern4 = "ABC";
    cout << "Text: \"" << text4 << "\"" << endl;
    cout << "Pattern: \"" << pattern4 << "\"" << endl;
    KMPSearch(text4, pattern4);
}
```
]

== 總結

KMP 演算法利用模式串自身的重複特性，避免了樸素演算法中不必要的回溯，從而將字串搜尋的時間複雜度優化到線性的 $O(m + n)$。其核心在於構建一個「部分匹配表」（LPS 陣列），該表指導了模式串在不匹配時如何高效地跳躍。掌握 KMP 演算法不僅能解決字串匹配問題，其背後的動態規劃思想和對問題結構的利用，對於理解其他演算法也大有裨益。
