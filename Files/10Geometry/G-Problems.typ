== Examples and Exercises
==== Problem: Luogu P2181
*Problem Statement*

For a convex polygon with $n$ vertices, no three diagonals intersect at the same point. Find the number of intersection points of the diagonals.

For example, a hexagon ($6$-gon):

#figure(image("../Images/Vector2.png", width: 50.0%),
  caption: none
)

*Input Description*

The input consists of a single line containing one integer $n$, the number of sides. $3 lt.eq n lt.eq 10^5$.

*Output Description*

Output a single line containing one integer representing the answer.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`4`], [`1`],
)

==== Problem: Luogu P1142 Bombing
*Problem Statement*

"What should I do?" Pilot klux asks for your help.

In fact, klux faces a very simple problem, but he is just too weak to solve it.

klux
wants to bomb some locations in a region — they are points on a plane — but (obviously) klux
faces resistance, so klux
can only fly once. And since the plane is rather broken, once it takes off it can only fly in a straight line and cannot turn. Now klux wants to bomb as many locations as possible in a single pass.

*Input Description*

The first line contains $n$.

The input consists of $n$ pairs of integers
$\( 1 lt.eq n lt.eq 700 \)$, each pair representing the coordinates of a point. No point appears twice.

*Output Description*

A single integer representing the maximum number of points that a single straight line can cover.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`5`#linebreak()`1 1`#linebreak()`2 2`#linebreak()`3 3`#linebreak()`9 10`#linebreak()`10 11`], [`3`],
)

==== Problem: Luogu P2180 Placing Stones
*Problem Statement*

Our great KK places $K$ stones on a grid formed by $N$ horizontal lines and $M$ vertical lines (KK's custom coordinate system). Each stone can only be placed at a grid intersection. KK wants to know, under the optimal placement, what is the maximum number of axis-aligned rectangles whose four corners each have exactly one stone placed on them.

*Input Description*

One line containing three positive integers $N$, $M$, $K$.

$0 < N \, M lt.eq 30000$, $K lt.eq N times M$

*Output Description*

One line containing one positive integer representing the maximum number of valid rectangles.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`3 3 8`], [`5`],
)

==== Problem: Luogu P1355 Mysterious Triangle
*Problem Statement*

Determine the positional relationship between a given point and a known triangle.

*Input Description*

The first three lines: one coordinate per line, representing the three vertices of the triangle.

The fourth line: the coordinates of a point; determine the relationship between this point and the triangle formed by the first three points.

(See the sample for details.)

All coordinate values are integers.

*Output Description*

If the point is inside the triangle (not including the boundary), output 1;

If the point is outside the triangle (not including the boundary), output 2;

If the point is on the boundary of the triangle (not including vertices), output 3;

If the point is on a vertex of the triangle, output 4.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`(0,0)`#linebreak()`(3,0)`#linebreak()`(0,3)`#linebreak()`(1,1)`], [`2 5 3 4 1`],
)

==== Problem: Luogu P3829 \[SHOI2012\] Credit Card Convex Hull
*Problem Statement*

A credit card is a rectangle with its four corners rounded into quarter-circles, each tangent to two sides of the rectangle, as shown below. Given some credit cards of identical dimensions on a plane, find the perimeter of their convex hull. Note that the convex hull is not necessarily a polygon, as it may include arc segments.

#figure(image("../Images/Vector3.png", width: 50.0%),
  caption: none
)

*Input Description*

The first line of input contains a positive integer $n$, the number of credit cards. The second line contains three real numbers
$a \, b \, r$, representing the vertical length, horizontal length, and the radius of the $1/4$ circle of the credit card (before rounding).

The following $n$ lines each contain three real numbers
$x \, y \, theta$, representing the horizontal coordinate, vertical coordinate of the center (i.e., the intersection of the diagonals) of a credit card, and the angle in radians it is rotated counterclockwise about its center.

*Output Description*

Output a single line containing one real number representing the perimeter of the convex hull, rounded to 2 decimal places.

*Sample Test*

#table(columns: (1fr, 1fr), stroke: .5pt, inset: 5pt,
  [Sample Input 1], [Sample Output 1],
  [`2`#linebreak()`6.0 2.0 0.0`#linebreak()`0.0 0.0 0.0`#linebreak()`2.0 -2.0 1.5707963268`], [`21.66`],
)
