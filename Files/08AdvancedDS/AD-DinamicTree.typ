#import "../../template.typ": *

== Dynamic Node Allocation
=== Introduction
The pointer-based segment tree we introduced earlier is actually already an example of this, but let me walk you through the underlying concept anyway.

=== Concept
Why use dynamic node allocation? Of course, to save memory. The more nodes you have, the more memory you consume. Sometimes the value range is too large, and that is when we can apply dynamic node allocation. In general, what counts as too large? Any range exceeding $10^6$ can be considered too large.

A common question is: why not use discretization (I only realized while writing this section that I may have forgotten to include it in Chapter 3, so I am rushing to add it now)? The answer is that sometimes we need the exact values. For example, in the rectangle area coverage problem from the previous unit, if you use discretization, the values get distorted and you will compute the wrong answer.

=== Implementation
The implementation was already shown earlier, so I will not paste it again. One thing to be careful about is not to dereference nullptr nodes, as that will cause a runtime error (RE) or segmentation fault (SEG). Also be careful with empty nodes during computation — some segment trees assign non-zero values to empty nodes.
