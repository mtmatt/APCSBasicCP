#import "../../template.typ": *

== 實作 STL 的資料結構

既然官方的函式庫裡面有這樣的東西，就表示我們可以做一個出來。

=== 實作 vector

#heading(level: 4, numbering: none, outlined: false)[核心概念：倍增法 (Doubling Strategy)]

在許多動態資料結構中，我們需要在執行期間擴充儲存空間。以 `Vector` (或 C++ 的 `std::vector`) 為例，當我們不斷使用 `push_back` 新增元素時，其內部預先分配的記憶體空間總有被用完的時候。

這時，我們必須：

+ 配置一塊#strong[更大的]新記憶體。

+ 將舊記憶體中的所有元素#strong[複製]到新記憶體。

+ #strong[釋放]舊的記憶體空間，以防記憶體洩漏。

+ 將指標指向新的記憶體位置。

關鍵問題是：新記憶體應該要多「大」？

- #strong[線性增長 (不好)]：如果每次都只增加一個固定的量 (例如 `capacity + 10`)，隨著元素數量 $n$ 的增長，重新配置記憶體的次數會越來越頻繁，導致 `push_back` 的平均時間複雜度變為 $O(n)$。

- #strong[倍增法 (Amortized O(1))]：如果我們每次都將空間擴充為原來的兩倍 (#strong[空間 $times 2$])，雖然單次擴充的成本很高 (需要 $O(n)$ 的時間複製元素)，但這種情況很少發生。經過均攤分析 (Amortized Analysis)，可以證明，在經過一系列 `push_back` 操作後，每個操作的#strong[平均時間複雜度為常數時間 $O(1)_("amortized")$]。這是一種空間換取時間的經典策略，確保了 `Vector` 的效能。

==== Vector.h

這是一個簡化版的 `Vector` 結構，用於儲存整數。

#listing([Vector])[
```cpp
struct Vector {
    // 建構子：初始化一個大小為 _sz 的 Vector
    // 容量 (capacity) 也會被設為 _sz
    Vector(int _sz = 0) : sz(_sz), capacity(_sz) {
        if (sz != 0) value = new int[sz];
        else value = nullptr;
    }
    // 解構子：釋放動態配置的記憶體
    ~Vector() {
        if (value != nullptr) delete [] value;
    }
    // 調整 Vector 的大小
    Vector& resize(int new_size);
    // 在尾端新增一個元素
    Vector& push_back(int val);
    // 移除尾端的元素
    Vector& pop_back();
    // 運算子重載，提供類似陣列的存取方式
    int& operator[](int index) { return value[index];}
    
    int *value;     // 指向動態配置陣列的指標
    int sz;         // 目前儲存的元素數量
    int capacity;   // 目前已配置的記憶體容量
};
```
]

==== Vector 實作

以下是 `push_back` 和 `resize` 的完整實作，這是 `Vector` 的核心。

#listing([Vector.cpp 的建議實作])[
```cpp
#include "Vector.h"

// push_back 是倍增法的關鍵所在
Vector& Vector::push_back(int val) {
    // 1. 檢查容量是否已滿
    if (sz == capacity) {
        // 2. 計算新容量。如果原容量為 0，則新容量設為 1，否則加倍。
        int new_capacity = (capacity == 0) ? 1 : capacity * 2;
        
        // 3. 配置新記憶體
        int *new_value = new int[new_capacity];
        
        // 4. 將舊資料複製到新記憶體
        for (int i = 0; i < sz; ++i) {
            new_value[i] = value[i];
        }
        
        // 5. 釋放舊記憶體
        if (value != nullptr) {
            delete[] value;
        }
        
        // 6. 更新指標和容量
        value = new_value;
        capacity = new_capacity;
    }
    
    // 7. 在尾端加入新元素，並更新大小
    value[sz] = val;
    sz++;
    
    return *this;
}

// pop_back 較為簡單，只需減少 size 即可
// 為了效率，我們不縮減容量 (std::vector 也是如此)
Vector& Vector::pop_back() {
    if (sz > 0) {
        sz--;
    }
    return *this;
}

// resize 處理大小變更，可能需要擴充或只是修改 sz
Vector& Vector::resize(int new_size) {
    // 如果新大小超過目前容量，則需要重新配置記憶體
    if (new_size > capacity) {
        int new_capacity = new_size; // 直接配置所需大小
        int *new_value = new int[new_capacity];
        
        // 複製舊資料
        for (int i = 0; i < sz; ++i) {
            new_value[i] = value[i];
        }
        
        if (value != nullptr) {
            delete[] value;
        }
        
        value = new_value;
        capacity = new_capacity;
    }
    // 對於新增加的空間，可以選擇性地初始化為 0
    for(int i = sz; i < new_size; ++i) {
        value[i] = 0;
    }
    
    // 最後更新 size
    sz = new_size;
    return *this;
}
```
]

==== 應用

即便我們知道有函式庫可以用，倍增法依舊是一個很有用的技巧，尤其是在處理#strong[未知範圍的搜索]問題時。

此外，有了動態陣列 (如 `std::vector`) 之後，#strong[堆疊 (Stack)] 與 #strong[佇列 (Queue)] 就可以被輕易地實作出來了。

=== 實作 Stack

首先我們來實作堆疊。你會發現，只要利用 `std::vector` 內建的功能，就可以非常方便地模擬出堆疊的結構。我們將 `vector` 的#strong[尾端]視為堆疊的#strong[頂端 (top)]。

- `push(value)`: 將新元素放到堆疊頂端 $arrow.r$ `vector.push_back(value)`

- `pop()`: 移除堆疊頂端的元素 $arrow.r$ `vector.pop_back()`

- `top()`: 查看堆疊頂端的元素 $arrow.r$ `vector.back()`

#listing([用 std::vector 實作 Stack])[
```cpp
#include <iostream>
#include <vector>

struct Stack {
    std::vector<int> values;
    Stack& push(int value);
    Stack& pop();
    int top();
    int size();
};

// 將元素推入堆疊頂端
Stack& Stack::push(int value) {
    // your code below
    values.push_back(value);
    // your code above
    return *this;
}

// 從堆疊頂端移除元素
Stack& Stack::pop() {
    // your code below
    // 加上 .empty() 檢查可以讓程式更穩健，避免在空堆疊上操作
    if (!values.empty()) {
        values.pop_back();
    }
    // your code above
    return *this;
}

// 回傳堆疊頂端的元素值
int Stack::top() {
    // your code below
    // 如果堆疊是空的，回傳 -1，否則回傳最尾端的元素
    if (values.empty()) {
        return -1;
    }
    return values.back();
    // your code above
}

int Stack::size() {
    return values.size();
}

const int PUSH{1};
const int POP{2};
const int TOP{3};

int main(void) {
    // 關閉 C++ stream 與 C stdio 的同步，加速 cin/cout
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(NULL);

    int operation_num;
    std::cin >> operation_num;

    Stack st;
    for (int i{0}; i < operation_num; ++i) {
        int op, value;
        std::cin >> op;
        switch (op) {
        case PUSH:
            std::cin >> value;
            st.push(value);
            std::cout << st.size() << "\n";
            break;
        case POP:
            st.pop();
            break;
        case TOP:
            std::cout << st.top() << "\n";
            break;
        }
    }
}
```
]

=== 實作 Queue

接著我們來實作佇列 (Queue)。佇列的特性是「先進先出 (FIFO)」。如果直接使用 `std::vector`，從尾端推入 (`push_back`) 很有效率，但從頭部彈出 (`erase(begin())`) 的時間複雜度是 $O(N)$，因為需要移動後方所有元素，這在資料量大時會非常慢。

為了解決這個問題，我們將利用 `std::vector` 模擬一個更高效的結構：#strong[環狀陣列 (Circular Array)]。

#heading(level: 3, numbering: none, outlined: false)[核心概念：環狀陣列]

我們使用兩個指標 `l` (left\/front) 和 `r` (right\/rear) 來標記佇列的頭部與尾部。

- `l`: 指向佇列的第一個元素。

- `r`: 指向佇列#strong[最後一個元素的下一個位置]。

- `sz`: 佇列中實際的元素數量。

- `capacity`: 底層 `vector` 的總容量。

當 `l` 或 `r` 指標移動到陣列末端時，我們會讓它「繞回」到陣列的開頭，這就是「環狀」的概念，可以透過模數運算 (`%`) 實現。

當佇列已滿 (`sz == capacity`) 且需要再次推入元素時，我們會進行#strong[擴容]，也就是題目提示的 `resize`。擴容時，我們會將環狀陣列中的元素「拉直」，並複製到一個更大的新陣列中。

#heading(level: 3, numbering: none, outlined: false)[程式實作]

#listing([用環狀陣列實作 Queue])[
```cpp
#include <iostream>
#include <vector>

struct Queue {
    // 建構子：初始化所有成員變數
    Queue(): sz(0), l(0), r(0), capacity(0) {}
    std::vector<int> values;
    int l, r, sz, capacity;
    void set_capacity(int new_capacity);
    Queue& push(int val);
    Queue& pop();
    int front();
    int size() { return sz; }
};

// 重新設定容量，並將環狀陣列拉直
void Queue::set_capacity(int new_capacity) {
    std::vector<int> new_values(new_capacity);
    // 將舊陣列中的元素按順序複製到新陣列
    for (int i = 0; i < sz; ++i) {
        new_values[i] = values[(l + i) % capacity];
    }
    // 更新 vector、指標和容量
    values = new_values;
    capacity = new_capacity;
    l = 0;      // 新的頭部在索引 0
    r = sz;     // 新的尾部在 sz 的位置
}

// 將元素推入佇列尾端
Queue& Queue::push(int val) {
    // Your code below
    // 如果佇列已滿，進行擴容 (使用倍增法)
    if (sz == capacity) {
        int new_capacity = (capacity == 0) ? 1 : capacity * 2;
        set_capacity(new_capacity);
    }
    // 將新元素放入尾端
    values[r] = val;
    // 更新尾端指標，並用 % 實現環狀移動
    r = (r + 1) % capacity;
    // 增加實際大小
    sz++;
    // Your code above
    return *this;
}

// 從佇列頭部彈出元素
Queue& Queue::pop() {
    // Your code below
    // 如果佇列內沒有任何元素，跳過指令
    if (sz == 0) {
        return *this;
    }
    // 更新頭部指標，並用 % 實現環狀移動
    l = (l + 1) % capacity;
    // 減少實際大小
    sz--;
    // Your code above
    return *this;
}

// 取得頭部元素的值
int Queue::front() {
    // Your code below
    // 如果佇列是空的，回傳 -1
    if (sz == 0) {
        return -1;
    }
    // 回傳頭部指標所指的元素
    return values[l];
    // Your code above
}

const int PUSH{1};
const int POP{2};
const int FRONT{3};

int main(void) {
    std::ios::sync_with_stdio(0);std::cin.tie(0);
    int operation_num;
    std::cin >> operation_num;

    Queue st;
    for (int i{0}; i < operation_num; ++i) {
        int op, value;
        std::cin >> op;
        switch (op) {
        case PUSH:
            std::cin >> value;
            st.push(value);
            std::cout << st.size() << "\n";
            break;
        case POP:
            st.pop();
            break;
        case FRONT:
            std::cout << st.front() << "\n";
            break;
        }
    }
}
```
]

=== 實作 Priority Queue

堆積是一種特殊的樹狀資料結構，它在陣列的基礎上，透過父子節點的索引關係來模擬樹的行為，因此效率很高。以下我們以\*\*最大堆積 (Max Heap)\*\* 為例，其必須滿足以下性質：

+ #strong[堆積性質 (Heap Property)]: 父節點 (Parent Node) 的值總是#strong[大於等於]其子節點 (Child Nodes) 的值。這確保了最大值永遠在樹的根節點。

+ #strong[結構性質 (Shape Property)]: 堆積是一個#strong[完全二元樹 (Complete Binary Tree)]。這意味著樹的每一層都是滿的，除了最底層；且最底層的節點都盡量靠左對齊。這個性質讓我們能用陣列來緊湊地儲存它。

#strong[二元樹 (Binary Tree)] 是一種每個節點最多只能有兩個子節點的樹狀結構。

==== Heap 主要操作

- #strong[Build Heap (建堆):] 將一個無序的陣列轉換成滿足堆積性質的結構。這個過程也稱為 #strong[Heapify]。

- #strong[Insert (插入):] 在堆積中插入一個新元素，同時維持堆積性質。

- #strong[Extract Max (取出最大值):] 移除並回傳堆積中的最大元素（即根節點），同樣要維持堆積性質。

==== 操作演算法詳解

為了實現上述操作，我們需要兩個核心的輔助函式：`sift_down`（下沉）和 `sift_up`（上浮）。

#strong[Sift Down (下沉)] 當某個節點的值小於其子節點，破壞了堆積性質時，我們讓它與其#strong[較大的子節點]交換位置，並一路向下重複此過程，直到它不再小於其子節點，或成為葉節點為止。這個操作是 #strong[Build Heap] 和 #strong[Extract Max] 的基礎。

#strong[Sift Up (上浮)] 當我們在堆積末端加入一個新元素時，這個新元素可能比其父節點大。我們讓它與其父節點交換位置，並一路向上重複此過程，直到它的值小於等於其父節點，或已到達根節點為止。這個操作是 #strong[Insert] 的基礎。

#heading(level: 4, numbering: none, outlined: false)[程式碼實作與詳解]

接下來，我們將實作一個最大堆積。我們使用 `std::vector` 來儲存資料，並透過索引計算來模擬父子關係。

- 索引為 ‘i‘ 的節點：

- 其左子節點索引為 ‘2\*i + 1‘

- 其右子節點索引為 ‘2\*i + 2‘

- 其父節點索引為 ‘(i - 1) \/ 2‘

下面的程式碼模板已經提供了這些索引計算的輔助函式。

#listing([用 Vector 實作 Heap])[
```cpp
#include <iostream>
#include <vector>
#include <functional> // for std::function
#include <algorithm>  // for std::swap

inline int left_child(int node) {
    return (node << 1) | 1;
}

inline int right_child(int node) {
    return (node << 1) + 2;
}

inline int parent(int node) {
    return (node - 1) >> 1;
}

class Heap {
public:
    Heap(const std::vector<int> &elements) : values(elements) {
        heapify();
    }
    void heapify();
    void push(int val);
    int pop_top();
private:
    // 輔助函式：讓節點 i 下沉以維持堆積性質
    void sift_down(int i);
    // 輔助函式：讓節點 i 上浮以維持堆積性質
    void sift_up(int i);
    std::vector<int> values;
};

// --- Helper Functions ---
void Heap::sift_down(int i) {
    int max_index = i;
    int l = left_child(i);
    // 檢查左子節點是否存在且大於目前節點
    if (l < values.size() && values[l] > values[max_index]) {
        max_index = l;
    }
    int r = right_child(i);
    // 檢查右子節點是否存在且大於目前最大值節點
    if (r < values.size() && values[r] > values[max_index]) {
        max_index = r;
    }
    // 如果最大值不是目前節點 i，則交換並遞迴下沉
    if (i != max_index) {
        std::swap(values[i], values[max_index]);
        sift_down(max_index);
    }
}

void Heap::sift_up(int i) {
    // 當節點不是根節點且比父節點大時，持續上浮
    while (i > 0 && values[i] > values[parent(i)]) {
        std::swap(values[i], values[parent(i)]);
        i = parent(i);
    }
}

// --- Public Methods ---
void Heap::heapify() {
    // Your code below
    // 從最後一個非葉節點開始，由下往上對每個節點執行 sift_down
    // 最後一個元素的索引是 values.size() - 1
    // 其父節點就是最後一個非葉節點
    for (int i = (values.size() / 2) - 1; i >= 0; --i) {
        sift_down(i);
    }
    // Your code above
}

void Heap::push(int val) {
    // Your code below
    // 1. 將新元素加入到陣列尾端
    values.push_back(val);
    // 2. 對新元素執行 sift_up，以維持堆積性質
    sift_up(values.size() - 1);
    // Your code above
}

int Heap::pop_top() {
    // Your code below
    if (values.empty()) {
        return -1; // 或拋出異常
    }
    // 1. 保存根節點的值
    int top_element = values[0];
    // 2. 將最後一個元素移到根節點
    values[0] = values.back();
    // 3. 移除陣列的最後一個元素
    values.pop_back();
    // 4. 如果堆積非空，對新的根節點執行 sift_down
    if (!values.empty()) {
        sift_down(0);
    }
    // Your code above
    return top_element;
}
```
]

=== 實作 Set 與 Map

Set 和 Map 是兩個非常常用的資料結構，分別用於儲存唯一元素和鍵值對。它們通常使用平衡二元搜尋樹 (如紅黑樹) 來實現，以確保操作的時間複雜度為 $O(log n)$。所以這對目前的你們來說，實作起來會有點困難。在競賽上會使用 Treap 取代。 Treap 將會在後面介紹。
