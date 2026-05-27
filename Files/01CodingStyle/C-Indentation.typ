#import "../../template.typ": *

== 縮排
=== 為什麼要縮排
你可能想說：「我程式可以執行就好了啊！」。但是你可以看看這個範例。

#code(title: [縮排的錯誤示範])[
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
int n,a=0,sum=0;
cin>>n;
for(int i=0;i<n;++i){
cin>>a;
if(a<120)
sum+=a;
}
cout<<sum<<"\n";
}
```
]

請問你能在20秒內了解這個程式在幹嘛嗎？如果可以，那你就比筆者強大了`^ ^`。(至少在程式碼識讀上)

即便如此，如果你遇到問題，被你問到的人都絕對不會想要看到這樣的程式碼，你如果傳這種給其他人，大概有99.99%的機率被退回。

=== 怎麼做比較好
程式撰寫風格是非常自由，但一個大原則就是要有可讀性。我所使用的縮排原則是，只要遇到函式(Function)、for, while迴圈、if, switch判斷式，都會在接下來多空 `2-4` 個空格(在vscode裡面)。

以下是一個範例。

#code(title: [縮排的合理示例])[
```cpp
#include<bits/stdc++.h>
using namespace std;

int main() {
    int a = 0, sum = 0;
    cin >> n;
    for(int i = 0; i < n; ++i) {
        cin >> a;
        if(a < 120)
            sum += a;
    }
    cout << sum << "\n";
}
```
]

在這樣的階層式架構下，只要是APCS觀念題有拿到3, 4級分的人應該都可以快速理解這段程式碼。

#tip[
程式碼撰寫上應以縮排的方式增加可讀性。在所有的程式碼中應用這樣的習慣，將有助於維護你寫的程式碼們。
]
