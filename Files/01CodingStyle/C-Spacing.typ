#import "../../template.typ": *

== Spacing
=== Disclaimer
The following suggestions are for reference only. Spacing conventions have always been a topic of endless debate. I will explain the reasoning behind my choices. Please choose the spacing style that suits your personal needs. (Just keep readability in mind.)

=== General Case
Because I shrink my code font to fit more lines on screen at once, I add spaces around operators so the code is easier to read.

#code(title: [My spacing habits (general case)])[
```cpp
void solve() {
    int a = 0, sum = 0;
    cout << sum << "\n";
}
```
]

#code(title: [Version without spaces])[
```cpp
void solve(){
    int a=0,sum=0;
    cout<<sum<<"\n";
}
```
]

You can probably tell that my code is more compact. If you do not like this style, you can use the second version. Both are widely accepted.

=== Special Cases
Thinking about the general case will naturally lead you to wonder about special situations. For readability, I add spaces in the following cases.

+ When using an `if` statement without wanting a line break.
+ When cramming two statements onto the same line.
+ When working with pointers.
+ When an expression is too complex.


Here are some examples.

#code(title: [Special cases])[
```cpp
void solve(){
    if(a<0) a=0;
    b++; c++;
    d->sum += e->sum;
    cout<<a + (b-c) - d->sum<<"\n";
}
```
]

That said, try to avoid these special cases as much as possible, since they can still make code harder to read.

#tip[
Use spacing in a way that is consistent and readable according to your own habits. You will notice that this chapter emphasizes readability, because I have seen so much code that was completely unreadable — code I had to manually reformat, wasting everyone's time.
]
