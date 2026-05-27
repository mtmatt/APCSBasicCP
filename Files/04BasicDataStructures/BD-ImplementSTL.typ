#import "../../template.typ": *

== Implementing STL Data Structures

Since the standard library already provides these structures, it means we can build them ourselves.

=== Implementing vector

==== Core Concept: Doubling Strategy

In many dynamic data structures, we need to expand storage at runtime. Taking `Vector` (or C++'s `std::vector`) as an example, when we keep using `push_back` to add elements, the internally pre-allocated memory will eventually run out.

At that point, we must:
+ Allocate a *larger* block of new memory.
+ *Copy* all elements from the old memory to the new memory.
+ *Free* the old memory space to prevent memory leaks.
+ Point the pointer to the new memory location.


The key question is: how "large" should the new memory be?

- *Linear growth (bad)*: If we only add a fixed amount each time (e.g., `capacity + 10`), as the number of elements $n$ grows, memory reallocations become increasingly frequent, causing the average time complexity of `push_back` to become $O(n)$.
- *Doubling strategy (Amortized O(1))*: If we expand the space to twice its original size (*space $times 2$*) each time, although the cost of a single expansion is high (it requires $O(n)$ time to copy elements), this situation occurs rarely. Through amortized analysis, it can be proven that after a series of `push_back` operations, the *average time complexity of each operation is constant* $O(1)_("amortized")$. This is a classic strategy of trading space for time, ensuring the performance of `Vector`.


==== Vector.h
This is a simplified `Vector` struct for storing integers.
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

==== Vector Implementation
Below is the complete implementation of `push_back` and `resize`, which are the core of `Vector`.

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

==== Applications

Even though we know the standard library is available, the doubling strategy remains a very useful technique, especially when dealing with *search problems with unknown bounds*.

Moreover, once we have a dynamic array (like `std::vector`), both a *Stack* and a *Queue* can be implemented with ease.

=== Implementing Stack

Let us first implement a stack. You will find that by using the built-in features of `std::vector`, the stack structure can be simulated very conveniently. We treat the *end* of the `vector` as the *top* of the stack.

- `push(value)`: place a new element on top of the stack $arrow.r$ `vector.push_back(value)`
- `pop()`: remove the element at the top of the stack $arrow.r$ `vector.pop_back()`
- `top()`: peek at the element at the top of the stack $arrow.r$ `vector.back()`


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

=== Implementing Queue

Next let us implement a queue. A queue follows the "First In, First Out (FIFO)" principle. If we use `std::vector` directly, pushing at the end (`push_back`) is efficient, but popping from the front (`erase(begin())`) has $O(N)$ time complexity because all subsequent elements must be shifted — this becomes very slow for large data.

To solve this problem, we will use `std::vector` to simulate a more efficient structure: a *Circular Array*.

==== Core Concept: Circular Array

We use two pointers, `l` (left/front) and `r` (right/rear), to mark the head and tail of the queue.
- `l`: points to the first element in the queue.
- `r`: points to *the position one past the last element* of the queue.
- `sz`: the actual number of elements in the queue.
- `capacity`: the total capacity of the underlying `vector`.

When the `l` or `r` pointer reaches the end of the array, we wrap it back to the beginning — this is the "circular" concept, implemented via the modulo operation (\verb|

When the queue is full (`sz == capacity`) and we need to push another element, we perform an *expansion*, i.e., the `resize` hinted at in the problem. During expansion, we "straighten out" the elements of the circular array and copy them into a larger new array.

==== Implementation

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

=== Implementing Priority Queue

A heap is a special tree-based data structure that simulates tree behavior on top of an array through parent-child index relationships, making it very efficient. Below we use a *Max Heap* as our example, which must satisfy the following properties:

+ *Heap Property*: The value of a parent node is always *greater than or equal to* the values of its child nodes. This ensures the maximum value is always at the root of the tree.
+ *Shape Property*: A heap is a *Complete Binary Tree*. This means every level of the tree is fully filled except possibly the last level, and nodes in the last level are packed as far left as possible. This property allows us to store it compactly in an array.


A *Binary Tree* is a tree structure where each node has at most two child nodes.

==== Main Heap Operations
- *Build Heap:* Transform an unsorted array into a structure that satisfies the heap property. This process is also called *Heapify*.
- *Insert:* Insert a new element into the heap while maintaining the heap property.
- *Extract Max:* Remove and return the maximum element (i.e., the root node) from the heap, while maintaining the heap property.


==== Detailed Operation Algorithms
To implement the above operations, we need two core helper functions: `sift_down` and `sift_up`.

*Sift Down*
When a node's value is smaller than its children, violating the heap property, we swap it with its *larger child* and repeat this process downward until it is no longer smaller than its children or it becomes a leaf node. This operation is the foundation of *Build Heap* and *Extract Max*.

*Sift Up*
When we add a new element at the end of the heap, this new element may be larger than its parent node. We swap it with its parent and repeat this process upward until its value is less than or equal to its parent, or it has reached the root node. This operation is the foundation of *Insert*.

==== Code Implementation

Next, we will implement a max heap. We use `std::vector` to store data and compute parent-child relationships via index arithmetic.

- For a node at index `i`:
- Its left child index is `2*i + 1`
- Its right child index is `2*i + 2`
- Its parent index is `(i - 1) / 2`

The code template below already provides helper functions for these index calculations.

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

=== Implementing Set and Map
Set and Map are two very commonly used data structures, used to store unique elements and key-value pairs respectively. They are typically implemented using a balanced binary search tree (such as a red-black tree) to ensure $O(log n)$ time complexity for operations. Therefore, implementing them from scratch would be quite difficult at this stage. In competitive programming, a Treap is used as a substitute. Treap will be introduced later.
