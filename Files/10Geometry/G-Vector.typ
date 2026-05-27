== Vectors
=== Concept
A vector is a quantity with direction, covered in high school mathematics. There are two ways to express a vector:
using an arrow or a sequence of numbers.

#figure(image("../Images/Vector.png", width: 20.0%),
  caption: none
)

$ arrow(v) = \( x_1 \, x_2 \, dots.h.c \, x_n \) $

In linear algebra, vectors are treated more abstractly, but we will not focus on that for now,
since problems requiring vectors in non-Euclidean spaces are typically very difficult.

In competitive programming, we most commonly use 2D planar vectors, and a point on the coordinate plane
can be viewed as a vector from $\( 0 \, 0 \)$ to that point.

=== Basic Operations
Vectors support several operations: addition, additive inverse, subtraction, scalar multiplication, vector length, and dot product.

First, addition: ignoring the geometric picture, vector addition is defined as adding each coordinate separately.

$ arrow(v) = \( v_1 \, v_2 \, dots.h.c \, v_n \) \, #h(0em) arrow(u) = \( u_1 \, u_2 \, dots.h.c \, u_n \) $

$ v + u = \( v_1 + u_1 \, v_2 + u_2 \, dots.h.c \, v_n + u_n \) $

The additive inverse $v^(- 1)$ is defined by $v + v^(- 1) = arrow(0)$, i.e., $- v$.

Subtraction is simply adding the additive inverse of a vector.

Scalar multiplication represents a scaling of the vector; if $k in bb(R)$ is the scalar:

$ k v = \( k v_1 \, k v_2 \, dots.h.c \, k v_n \) $

The vector length is the distance from the vector to the origin.

$ arrow(v) = \( v_1 \, v_2 \, dots.h.c \, v_n \) \, #h(0em) \| v \| = sqrt(v_1^2 \, v_2^2 \, dots.h.c \, v_n^2) $

The dot product is defined as the length of one vector multiplied by the projection length of the other vector onto it.

$ v dot.op u = \| v \| times \| u \| times cos theta $

where `theta` is the angle between the two vectors.

It can be shown that
$v dot.op u = v_1 times u_1 + v_2 times u_2 + dots.h.c + v_n times u_n$

#block[
#emph[Proof.]
$ v = \( v_1 \, v_2 \, dots.h.c \, v_n \) \, u = \( u_1 \, u_2 \, dots.h.c \, u_n \) $

$ \| v \| = sqrt(v_1^2 \, v_2^2 \, dots.h.c \, v_n^2) \, \| u \| = sqrt(u_1^2 \, u_2^2 \, dots.h.c \, u_n^2) $

$ \| v \|^2 = v_1^2 \, v_2^2 \, dots.h.c \, v_n^2 \, \| u \|^2 = u_1^2 \, u_2^2 \, dots.h.c \, u_n^2 $

$ \| v - u \|^2 & = \( v_1 - u_1 \)^2 \, \( v_2 - u_2 \)^2 \, dots.h.c \, \( v_n - u_n \)^2\
 & = sum_(i = 1)^n \( v_i - u_i \)^2\
 & = sum_(i = 1)^n \( v_i^2 + u_i^2 - 2 times v_i times u_i \) $

$ cos theta & = frac(\| v \|^2 + \| u \|^2 - \| v - u \|^2, 2 times \| v \| times \| u \|)\
 & = frac(sum_(i = 1)^n v_i^2 + sum_(i = 1)^n u_i^2 - sum_(i = 1)^n \( v_i^2 + u_i^2 - 2 times v_i times u_i \), 2 times \| v \| times \| u \|)\
 & = frac(sum_(i = 1)^n \( 2 times v_i times u_i \), 2 times \| v \| times \| u \|)\
 & = frac(sum_(i = 1)^n \( v_i u_i \), \| v \| \| u \|)\
 $

$ v dot.op u & = \| v \| \| u \| cos theta = \| v \| \| u \| times frac(sum_(i = 1)^n \( v_i u_i \), \| v \| \| u \|)\
 & = sum_(i = 1)^n \( v_i times u_i \) $~◻

]
=== Implementation
We use a struct to conveniently work with 2D vectors.

==== Code: 2D vector

```
using T=long long;
struct Pt {// point
    T x,y;

    Pt()        { x=0, y=0;}
    Pt(T a,T b) { x=a, y=b;}

    void operator+=(const Pt a) { x+=a.x, y+=a.y;}
    void operator-=(const Pt a) { x-=a.x, y-=a.y;}
    void operator*=(const T a)  { x*=a, y*=a;}
    bool operator==(const Pt b) { return x==b.x && y==b.y;}
    bool operator!=(const Pt b) { return x!=b.x || x==b.y;}

    Pt operator+(const Pt a) { return Pt(x+a.x,y+a.y);}
    Pt operator-(const Pt a) { return Pt(x-a.x,y-a.y);}
    Pt operator*(const T a)  { return Pt(x*a,y*a);}
    Pt operator/(const T a)  { return Pt(x/a,y/a);}

    double len() {
        return sqrt(x*x + y*y);
    }

    T norm() {
        return x*x + y*y;
    }
};

T dot(const Pt a, const Pt b)  { return a.x*b.x + a.y*b.y;}
```
