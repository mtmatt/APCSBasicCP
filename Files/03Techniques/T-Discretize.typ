#import "../../template.typ": *

== 離散化
=== 概念
離散化是排序的一個經典應用，可以將過大的值域範圍壓縮到$10^6$左右。 首先，為什麼要壓縮值域，這是一個很好的問題，我們看以下範例。

==== 範例: CSES 1619 Restaurant Customers

*題目敘述*

你有n個顧客在餐廳的到達和離開時間。請問在任何時間，餐廳中最多有多少顧客？

*輸入說明*

第一行輸入一個整數n：顧客數量。

之後，有n行描述顧客。每行有兩個整數$a$和$b$：一個顧客的到達時間和離開時間。

$1 <= n <= 2 times 10^5$，$1 <= a < b <= 10^9$

*輸出說明*

輸出一個整數：最多顧客的數量。

*想法*
有一個很容易的解(我竟然還沒有寫差分，如果有空再補)就是標記所有進出時間，也就是在進入的時候+1，出去的時候-1， 最後從頭到尾掃過陣列一次，並記錄最大值就可以了。

#code(title: [差分範例])[
```cpp
const int N=400010;

struct cus{
    int a,b;
};

int d[N];

int main(){
    // input and pre-process

    for(int i=0;i<n;++i){
        d[cs[i].a]++;
        d[cs[i].b+1]--;
    }

    int psum=0,pmx=0;
    for(int i=1;i<N;++i){
        psum+=d[i];
        pmx=max(psum,pmx);
    }

    cout<<pmx<<"\n";
}
```
]

但是我們看到a和b都有很大的範圍。在這種情況下，我們可以使用離散化來縮小範圍。
其中，`unique()`函式可以將重複的東西刪除，而`resize()`會重新分配記憶體空間給`vector`，讓大小符合刪除完之後的元素個數。

#code(title: [離散化範例])[
```cpp
const int N=400010;

struct cus{
    int a,b;
};

int d[N];

int main(){
    int n;
    cin>>n;

    vector<cus> cs(n);
    vector<int> dis;

    for(int i=0;i<n;++i){
        cin>>cs[i].a>>cs[i].b;
        dis.emplace_back(cs[i].a);
        dis.emplace_back(cs[i].b);
    }

    sort(dis.begin(),dis.end());
    dis.resize(unique(dis.begin(),dis.end())-dis.begin());

    for(int i=0;i<n;++i){
        cs[i].a=lower_bound(dis.begin(),dis.end(),cs[i].a)-dis.begin()+1;
        cs[i].b=lower_bound(dis.begin(),dis.end(),cs[i].b)-dis.begin()+1;
    }
}
```
]

*另解*

其實也可以透過`map<int,int>`解決這個問題，有興趣的同學可以試試看。

=== 注意事項
離散化只能用在壓縮值域的值並不是計算的重點時，因為如果計算上值很重要，那就會導致你更改到數值，進而吃WA。所以離散化只能用在，只需要考慮值的不同，或是大小順序即可的題目。

另外就是像上面說的，大多時候都可以用其他方法替代(後面還有其他範例)，所以也可以不用學(誤)。
