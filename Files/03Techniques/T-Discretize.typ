#import "../../template.typ": *

== Discretization
=== Concept
Discretization is a classic application of sorting; it can compress a very large value range down to around $10^6$. First, why do we need to compress the value range? That is a great question. Let's look at the following example.

==== Example: CSES 1619 Restaurant Customers

*Problem Statement*

You have n customers with their arrival and departure times at a restaurant. What is the maximum number of customers present in the restaurant at any point in time?

*Input Format*

The first line contains an integer n: the number of customers.

The following n lines each describe a customer. Each line contains two integers $a$ and $b$: the arrival time and departure time of a customer.

$1 <= n <= 2 times 10^5$，$1 <= a < b <= 10^9$

*Output Format*

Output a single integer: the maximum number of customers present.

*Idea*
There is a straightforward solution (I haven't written the difference array section yet; I'll add it when I have time): mark all entry and exit times, that is, add +1 at entry and -1 at exit, then scan through the array once from start to finish and record the maximum value.

#code(title: [Difference Array Example])[
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

However, we can see that a and b have a very large range. In this case, we can use discretization to shrink the range.
The `unique()` function removes duplicate elements, and `resize()` reallocates memory for the vector so that its size matches the number of remaining elements after removal.

#code(title: [Discretization Example])[
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

*Alternative*

This problem can also be solved using a `map<int,int>`. Interested readers may try it out.

=== Notes
Discretization can only be used when the actual values being compressed are not the focus of the computation. If the exact values matter for the calculation, changing them will lead to incorrect answers (WA). Therefore, discretization is only applicable to problems where only the distinctness of values or their relative order needs to be considered.

Additionally, as mentioned above, most of the time there are other methods to substitute for discretization (more examples will appear later), so you can choose not to learn it (just kidding).
