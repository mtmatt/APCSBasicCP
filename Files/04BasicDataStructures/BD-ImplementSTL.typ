#import "../../template.typ": *

== 實作 STL 的資料結構

既然官方的函式庫裡面有這樣的東西，就表示我們可以做一個出來。

=== 實作 Vector

==== 核心概念：倍增法 (Doubling Strategy)

在許多動態資料結構中，我們需要在執行期間擴充儲存空間。以 #raw("Vector") (或 C++ 的 #raw("std::vector")) 為例，當我們不斷使用 #raw("push_back") 新增元素時，其內部預先分配的記憶體空間總有被用完的時候。

這時，我們必須：
+ 配置一塊*更大的*新記憶體。
+ *複製*所有舊記憶體中的元素到新記憶體。
+ *釋放*舊的記憶體空間，以防記憶體洩漏。
+ 將指標指向新的記憶體位置。


關鍵問題是：新記憶體應該要多「大」？

- *線性增長 (不好)*：如果每次都只增加一個固定的量 (例如 #raw("capacity + 10"))，隨著元素數量 $n$ 的增長，重新配置記憶體的次數會越來越頻繁，導致 #raw("push_back") 的平均時間複雜度變為 $O(n)$。
- *倍增法 (Amortized O(1))*：如果我們每次都將空間擴充為原來的兩倍 (*空間 $times 2$*)，雖然單次擴充的成本很高 (需要 $O(n)$ 的時間複製元素)，但這種情況很少發生。經過均攤分析 (Amortized Analysis)，可以證明，在經過一系列 #raw("push_back") 操作後，每個操作的*平均時間複雜度為常數時間 $O(1)_("amortized")$*。這是一種空間換取時間的經典策略，確保了 #raw("Vector") 的效能。


==== Vector.h
這是一個簡化版的 #raw("Vector") 結構，用於儲存整數。
#code(title: [Vector])[
```cpp
struct Vector {
    // Constructor: initializes a Vector of size _sz
    // Capacity is also set to _sz
    Vector(int _sz = 0) : sz(_sz), capacity(_sz) {
        if (sz != 0) value = new int[sz];
        else value = nullptr;
    }
    // Destructor: frees dynamically allocated memory
    ~Vector() {
        if (value != nullptr) delete [] value;
    }
    // Resize the Vector
    Vector& resize(int new_size);
    // Add an element at the end
    Vector& push_back(int val);
    // Remove the element at the end
    Vector& pop_back();
    // Operator overload, provides array-like access
    int& operator[](int index) { return value[index];}

    int *value;     // pointer to the dynamically allocated array
    int sz;         // current number of stored elements
    int capacity;   // current allocated memory capacity
};
```
]

==== Vector 實作
以下是 #raw("push_back") 和 #raw("resize") 的完整實作，這是 #raw("Vector") 的核心。

#code(title: [Suggested implementation for Vector.cpp])[
```cpp
#include "Vector.h"

// push_back is the key to the doubling strategy
Vector& Vector::push_back(int val) {
    // 1. Check if capacity is full
    if (sz == capacity) {
        // 2. Compute new capacity. If original capacity is 0, set to 1; otherwise double it.
        int new_capacity = (capacity == 0) ? 1 : capacity * 2;

        // 3. Allocate new memory
        int *new_value = new int[new_capacity];

        // 4. Copy old data to new memory
        for (int i = 0; i < sz; ++i) {
            new_value[i] = value[i];
        }

        // 5. Free old memory
        if (value != nullptr) {
            delete[] value;
        }

        // 6. Update pointer and capacity
        value = new_value;
        capacity = new_capacity;
    }

    // 7. Append new element at the end and update size
    value[sz] = val;
    sz++;

    return *this;
}

// pop_back is simpler — just decrement size
// For efficiency, we do not shrink capacity (same as std::vector)
Vector& Vector::pop_back() {
    if (sz > 0) {
        sz--;
    }
    return *this;
}

// resize handles size changes, which may require expansion or just modifying sz
Vector& Vector::resize(int new_size) {
    // If the new size exceeds current capacity, reallocate memory
    if (new_size > capacity) {
        int new_capacity = new_size; // allocate exactly what is needed
        int *new_value = new int[new_capacity];

        // Copy old data
        for (int i = 0; i < sz; ++i) {
            new_value[i] = value[i];
        }

        if (value != nullptr) {
            delete[] value;
        }

        value = new_value;
        capacity = new_capacity;
    }
    // Optionally initialize newly added space to 0
    for(int i = sz; i < new_size; ++i) {
        value[i] = 0;
    }

    // Finally update size
    sz = new_size;
    return *this;
}
```
]

==== 應用

即便我們知道有函式庫可以用，倍增法依舊是一個很有用的技巧，尤其是在處理*未知範圍的搜索*問題時。

此外，有了動態陣列 (如 #raw("std::vector")) 之後，*堆疊 (Stack)* 與 *佇列 (Queue)* 就可以被輕易地實作出來了。

=== 實作 Stack

首先我們來實作堆疊 (Stack)。你會發現，只要利用 #raw("std::vector") 內建的功能，就可以非常方便地模擬出堆疊的結構。我們將 #raw("vector") 的*尾端*視為堆疊的*頂端 (top)*。

- #raw("push(value)") : 將新元素放到堆疊頂端 $arrow.r$ #raw("vector.push_back(value)")
- #raw("pop()") : 移除堆疊頂端的元素 $arrow.r$ #raw("vector.pop_back()")
- #raw("top()") : 查看堆疊頂端的元素 $arrow.r$ #raw("vector.back()")


#code(title: [Implementing Stack with std::vector])[
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

// Push an element onto the top of the stack
Stack& Stack::push(int value) {
    // your code below
    values.push_back(value);
    // your code above
    return *this;
}

// Remove the element at the top of the stack
Stack& Stack::pop() {
    // your code below
    // Adding an .empty() check makes the code more robust, avoiding operations on an empty stack
    if (!values.empty()) {
        values.pop_back();
    }
    // your code above
    return *this;
}

// Return the value of the element at the top of the stack
int Stack::top() {
    // your code below
    // If the stack is empty, return -1; otherwise return the last element
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
    // Disable synchronization between C++ streams and C stdio to speed up cin/cout
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

接著我們來實作佇列 (Queue)。佇列的特性是「先進先出 (FIFO)」。如果直接使用 #raw("std::vector")，從尾端推入 (#raw("push_back")) 很有效率，但從頭部彈出 (#raw("erase(begin())")) 的時間複雜度是 $O(N)$，因為需要移動後方所有元素，這在資料量大時會非常慢。

為了解決這個問題，我們將利用 #raw("std::vector") 模擬一個更高效的結構：*環狀陣列 (Circular Array)*。

==== 核心概念：環狀陣列

我們使用兩個指標 #raw("l") (left/front) 和 #raw("r") (right/rear) 來標記佇列的頭部與尾部。
- #raw("l"): 指向佇列的第一個元素。
- #raw("r"): 指向佇列*最後一個元素的下一個位置*。
- #raw("sz"): 佇列中實際的元素數量。
- #raw("capacity"): 底層 #raw("vector") 的總容量。

當 #raw("l") 或 #raw("r") 指標移動到陣列末端時，我們會讓它「繞回」到陣列的開頭，這就是「環狀」的概念，可以透過模數運算 (#raw("%")) 實現。

當佇列已滿 (#raw("sz == capacity")) 且需要再次推入元素時，我們會進行*擴容*，也就是題目提示的 #raw("resize")。擴容時，我們會將環狀陣列中的元素「拉直」，並複製到一個更大的新陣列中。

==== 程式實作

#code(title: [Implementing Queue with a Circular Array])[
```cpp
#include <iostream>
#include <vector>

struct Queue {
    // Constructor: initialize all member variables
    Queue(): sz(0), l(0), r(0), capacity(0) {}
    std::vector<int> values;
    int l, r, sz, capacity;
    void set_capacity(int new_capacity);
    Queue& push(int val);
    Queue& pop();
    int front();
    int size() { return sz; }
};

// Reset capacity and straighten out the circular array
void Queue::set_capacity(int new_capacity) {
    std::vector<int> new_values(new_capacity);
    // Copy elements from the old array in order to the new array
    for (int i = 0; i < sz; ++i) {
        new_values[i] = values[(l + i) % capacity];
    }
    // Update the vector, pointers, and capacity
    values = new_values;
    capacity = new_capacity;
    l = 0;      // new head is at index 0
    r = sz;     // new tail is at position sz
}

// Push an element onto the back of the queue
Queue& Queue::push(int val) {
    // Your code below
    // If the queue is full, expand capacity (using the doubling strategy)
    if (sz == capacity) {
        int new_capacity = (capacity == 0) ? 1 : capacity * 2;
        set_capacity(new_capacity);
    }
    // Place the new element at the tail
    values[r] = val;
    // Update the tail pointer, wrapping around with %
    r = (r + 1) % capacity;
    // Increment the actual size
    sz++;
    // Your code above
    return *this;
}

// Pop an element from the front of the queue
Queue& Queue::pop() {
    // Your code below
    // If the queue has no elements, skip the operation
    if (sz == 0) {
        return *this;
    }
    // Update the head pointer, wrapping around with %
    l = (l + 1) % capacity;
    // Decrement the actual size
    sz--;
    // Your code above
    return *this;
}

// Get the value of the front element
int Queue::front() {
    // Your code below
    // If the queue is empty, return -1
    if (sz == 0) {
        return -1;
    }
    // Return the element at the head pointer
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

堆積是一種特殊的樹狀資料結構，它在陣列的基礎上，透過父子節點的索引關係來模擬樹的行為，因此效率很高。以下我們以*最大堆積 (Max Heap)* 為例，其必須滿足以下性質：

+ *堆積性質 (Heap Property)*: 父節點 (Parent Node) 的值總是*大於等於*其子節點 (Child Nodes) 的值。這確保了最大值永遠在樹的根節點。
+ *結構性質 (Shape Property)*: 堆積是一個*完全二元樹 (Complete Binary Tree)*。這意味著樹的每一層都是滿的，除了最底層；且最底層的節點都盡量靠左對齊。這個性質讓我們能用陣列來緊湊地儲存它。


*二元樹 (Binary Tree)* 是一種每個節點最多只能有兩個子節點的樹狀結構。

==== Heap 主要操作
- *Build Heap (建堆):* 將一個無序的陣列轉換成滿足堆積性質的結構。這個過程也稱為 *Heapify*。
- *Insert (插入):* 在堆積中插入一個新元素，同時維持堆積性質。
- *Extract Max (取出最大值):* 移除並回傳堆積中的最大元素（即根節點），同樣要維持堆積性質。


==== 操作演算法詳解
為了實現上述操作，我們需要兩個核心的輔助函式：#raw("sift_down")（下沉）和 #raw("sift_up")（上浮）。

*Sift Down (下沉)*
當某個節點的值小於其子節點，破壞了堆積性質時，我們讓它與其*較大的子節點*交換位置，並一路向下重複此過程，直到它不再小於其子節點，或成為葉節點為止。這個操作是 *Build Heap* 和 *Extract Max* 的基礎。

*Sift Up (上浮)*
當我們在堆積末端加入一個新元素時，這個新元素可能比其父節點大。我們讓它與其父節點交換位置，並一路向上重複此過程，直到它的值小於等於其父節點，或已到達根節點為止。這個操作是 *Insert* 的基礎。

==== 程式碼實作與詳解

接下來，我們將實作一個最大堆積。我們使用 #raw("std::vector") 來儲存資料，並透過索引計算來模擬父子關係。

- 索引為 #raw("i") 的節點：
- 其左子節點索引為 #raw("2*i + 1")
- 其右子節點索引為 #raw("2*i + 2")
- 其父節點索引為 #raw("(i - 1) / 2")
下面的程式碼模板已經提供了這些索引計算的輔助函式。

#code(title: [Implementing Heap with Vector])[
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
    // Helper: let node i sift down to maintain heap property
    void sift_down(int i);
    // Helper: let node i sift up to maintain heap property
    void sift_up(int i);
    std::vector<int> values;
};

// --- Helper Functions ---
void Heap::sift_down(int i) {
    int max_index = i;
    int l = left_child(i);
    // Check if left child exists and is greater than the current node
    if (l < values.size() && values[l] > values[max_index]) {
        max_index = l;
    }
    int r = right_child(i);
    // Check if right child exists and is greater than the current maximum node
    if (r < values.size() && values[r] > values[max_index]) {
        max_index = r;
    }
    // If the maximum is not node i, swap and recursively sift down
    if (i != max_index) {
        std::swap(values[i], values[max_index]);
        sift_down(max_index);
    }
}

void Heap::sift_up(int i) {
    // While the node is not the root and is greater than its parent, keep sifting up
    while (i > 0 && values[i] > values[parent(i)]) {
        std::swap(values[i], values[parent(i)]);
        i = parent(i);
    }
}

// --- Public Methods ---
void Heap::heapify() {
    // Your code below
    // Starting from the last non-leaf node, call sift_down on each node from bottom to top
    // The index of the last element is values.size() - 1
    // Its parent is the last non-leaf node
    for (int i = (values.size() / 2) - 1; i >= 0; --i) {
        sift_down(i);
    }
    // Your code above
}

void Heap::push(int val) {
    // Your code below
    // 1. Append the new element at the end of the array
    values.push_back(val);
    // 2. Sift up the new element to maintain heap property
    sift_up(values.size() - 1);
    // Your code above
}

int Heap::pop_top() {
    // Your code below
    if (values.empty()) {
        return -1; // or throw an exception
    }
    // 1. Save the root's value
    int top_element = values[0];
    // 2. Move the last element to the root
    values[0] = values.back();
    // 3. Remove the last element from the array
    values.pop_back();
    // 4. If the heap is non-empty, sift down the new root
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
