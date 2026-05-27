#import "../../template.typ": *

== Indentation
=== Why Indent?
You might say: "As long as my code runs, isn't that enough?" But take a look at this example.

#code(title: [Bad indentation example])[
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

Can you understand what this program does within 20 seconds? If so, you are stronger than the author `^ ^`. (At least in terms of code reading.)

Even so, if you run into trouble, anyone you ask for help will absolutely not want to look at code like this. If you send this to someone, there is a 99.99% chance it gets sent back.

=== How to Do It Better
Coding style is very flexible, but one overriding principle is readability. My indentation rule is: whenever you encounter a function, a `for` or `while` loop, or an `if` or `switch` statement, indent the following block by `2-4` extra spaces (in VS Code).

Here is an example.

#code(title: [A reasonable indentation example])[
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

With this kind of hierarchical structure, anyone who scored a 3 or 4 on the APCS concepts portion should be able to quickly understand this code.

#tip[
Code should use indentation to improve readability. Applying this habit consistently across all your code will make it much easier to maintain.
]
