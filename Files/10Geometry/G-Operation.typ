== Operations
=== Area Calculation
We can use the determinant to compute the area of the parallelogram spanned by $v$ and $u$. Note that
the area has a sign: if $v$ rotated clockwise is closer to $u$, the result is positive; otherwise it is negative.

$ a r e a \( v \, u \) = \( v_1 u_2 - v_2 u_1 \) $

#block[
#emph[Proof.]
$ cos theta & = frac(sum_(i = 1)^n \( 2 times v_i times u_i \), 2 times \| v \| times \| u \|)\
 & = frac(v_1 u_1 + v_2 u_2, \| v \| times \| u \|)\
sin theta & = sqrt(1 - cos^2 theta)\
 & = frac(sqrt(\( \| v \| \| u \| \)^2 - \( v_1 u_1 + v_2 u_2 \)), \| v \| \| u \|)\
 & = frac(sqrt(\( v_1^2 + v_2^2 \) \( u_1^2 + u_2^2 \) - \( v_1 u_1 + v_2 u_2 \)^2), \| v \| \| u \|)\
 & = frac(v_1 u_2 - v_2 u_1, \| v \| \| u \|)\
a r e a \( v \, u \) & = \| v \| \| u \| sin theta\
 & = v_1 u_2 - v_2 u_1 $~◻

]
This property lets us determine the relative orientation of two vectors.

In practice, we call this the cross product (with $z$ set to 0).

==== Code: Area Calculation

```
T cross(const Pt a,const Pt b) { return a.x*b.y - a.y*b.x;}

int ori(const Pt a,const Pt b) {// positive negative zero
    T ret=cross(a,b);
    if(ret==0) return 0;
    return (ret<0)?-1:1;
}
```

=== Determining Whether a Point Lies on a Line
We can determine this using vector arithmetic. Point $C$ lies on line $accent(A B, ⃡)$
$arrow.l.r.double accent(A C, ⃗) = k accent(A B, ⃗) \, #h(0em) k in bb(R)$.

Checking whether $accent(A C, ⃗) = k accent(A B, ⃗)$ holds is straightforward: since the two
vectors are parallel, the area they span is $0$. Therefore,
we can check using $c r o s s \( C - A \, B - A \) = 0$.

=== Determining Whether a Point Lies on a Segment
We can determine this using vector arithmetic. For point $C$ to lie on segment $overline(A B)$,
it must first lie on line $accent(A B, ⃡)$. Then,
the angle between $accent(C A, ⃗)$ and $accent(C B, ⃗)$ must be $180^compose$.

$ arrow.r.double.long accent(C A, ⃗) dot.op accent(C B, ⃗) < 0 $

=== Determining Whether Two Segments Intersect
First, consider the case where an endpoint of one segment lies on the other segment — that counts as an intersection.

Beyond that, the situation is a bit more complex.
You can solve a system of equations and check whether the intersection point lies within both segments.
Here we introduce another approach: let the two segments be AB and CD.

$ upright("cross") \( accent(A B, ⃗) \, accent(A C, ⃗) \) times upright("cross") \( accent(A B, ⃗) \, accent(A D, ⃗) \) < 0\
upright("cross") \( accent(C D, ⃗) \, accent(C A, ⃗) \) times upright("cross") \( accent(C D, ⃗) \, accent(C B, ⃗) \) < 0 $

Thinking about when the cross product is positive or negative confirms the correctness of this approach.

=== Polygon Area
Consider using the shoelace formula. Let the vertices of the polygon be $P_1 \, P_2 \, dots.h.c \, P_n$:

$ a r e a \( P \) = sum_(i = 1)^n accent(O P_i, ⃗) times accent(O P_(i + 1), ⃗) \, #h(0em) "define" #h(0em) n + 1 = 1 $

A single loop handles this. Note that the vertices must be sorted either clockwise or counterclockwise; the following sections explain how to do that.

=== Polar Angle Sort
This is the process of sorting vertices in clockwise or counterclockwise order.

First, trigonometric functions have large constant factors because they are implemented using Taylor series and similar methods, so the following approach works but is slow.

==== Code: Polar Angle Sort with Inverse Trig

```
bool cmp(Pt a,Pt b){
    return atan2(a.x,a,y)<atan2(b.x,b.y);
}
```

Another approach uses the cross product and properties of the coordinate plane. Since the cross product only covers $180^compose$,
we must split the upper and lower (or left and right) half-planes.

==== Code: Polar Angle Sort with Cross Product

```
bool cmp(Pt a,Pt b){
    bool f1=a.x<0 || (a.x==0 && a.y<0);
    bool f2=b.x<0 || (b.x==0 && b.y<0);
    if(f1!=f2) return f1<f2;
    return cross(a,b)>0;
}
```

=== Convex Hull
Given a set of points, find the smallest convex polygon that contains all of them.

Such a polygon can always be found by sorting lexicographically by $x$ then $y$, and trying to add points one by one.

If the angle exceeds $180^compose$, remove the interior point.

Perform this operation twice: once from $1 arrow.r n$, and once from $n arrow.r 1$.

To check whether an angle exceeds $180^compose$: if
$upright("cross") \( accent(A B, ⃗) \, accent(B C, ⃗) \) lt.eq 0$, then $B$
is not on the convex hull.

==== Code: Convex Hull

```
vector<Pt> ConvexHull(vector<Pt> ds){
    sort(ds.begin(),ds.end(),CmpByXY);

    vector<Pt> ret;
    int k=0;
    for(auto i:ds){
        while(k>=2 && ori(ret[k-1]-ret[k-2],i-ret[k-1])<=0) {
            ret.pop_back();
            k--;
        }

        ret.emplace_back(i);
        k++;
    }

    ret.pop_back();
    k--;

    reverse(ds.begin(),ds.end());

    int hf=k;
    for(auto i:ds){
        while(k-hf>=2 && ori(ret[k-1]-ret[k-2],i-ret[k-1])<=0) {
            ret.pop_back();
            k--;
        }

        ret.emplace_back(i);
        k++;
    }
    ret.pop_back();// not count right element twice
    return ret;
}
```

The convex hull can be applied to finding the farthest pair of points, because if the coordinate range is $C$,
the convex hull has at most $sqrt(C)$ points. Enumerating all pairs has complexity $O \( C \)$.

It may also be useful for DP optimizations.

=== Additional Resources
#link("https://hackmd.io/@Ccucumber12/BJeOhtzbF#/")

#box(image("../Images/Vector1.png", width: 20.0%))
