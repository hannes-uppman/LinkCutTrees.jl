# LinkCutTrees.jl

This is a simple Julia implementation of Sleator and Tarjan's link/cut tree data structure.
This data structure is used for representing a collection of rooted trees and supports the operations:

- `link!(v, w, i, c)`, join two trees by making `v` (a root node) a child of `w` (an arbitrary node), set edge label `i` and (non-negative) edge cost `c`,
- `cut!(v)`, split a tree by disconnecting `v` from its parent,
- `find_root(v)`, return the root of the tree that contains `v`,
- `find_mincost(v)`, return `(w, c)`, with `w` as close to the root as possible, such that the edge from `w` to its parent is of minimum cost and `c` is this cost,
- `add_cost!(v, x)`, add `x` to the cost of each vertex on the path from `v` to the root.

The operations all run in `O(log n)` amortized time.

These operations are also supported:

- `cost(v)`, return the cost of the edge from `v` to its parent,
- `parent(v)`, get the parent of `v`,
- `label(v)`, get the label of `v`,
- `edge_label(v)`, return the label of the edge from `v` to its parent,
- `make_tree(T, U, V, i)`, create a tree with one node labeled `i`.

The operations `cost(v)` and `parent(v)` run in `O(log n)` amortized time, the other in `O(1)` time.

There are different ways to implement link/cut trees.
This implementation follows the version from Tarjan's book "Data Structures and Network Algorithms".

Examples:

```julia
julia> using LinkCutTrees

julia> n1 = make_tree(Int, Nothing, Int, 1);

julia> n2 = make_tree(Int, Nothing, Int, 2);

julia> n3 = make_tree(Int, Nothing, Int, 3);

julia> link!(n2, n1, nothing, 1)

julia> link!(n3, n1, nothing, 2)

julia> find_root(n2) === find_root(n3) === n1
true

julia> cut!(n3)

julia> n3 === find_root(n3)
true
```

```julia
julia> using LinkCutTrees

julia> n1 = make_tree(Int, Int, Int, 1);

julia> n2 = make_tree(Int, Int, Int, 2);

julia> n3 = make_tree(Int, Int, Int, 3);

julia> n4 = make_tree(Int, Int, Int, 4);

julia> n5 = make_tree(Int, Int, Int, 5);

julia> link!(n2, n1, 1, 100)

julia> link!(n3, n2, 2, 10)

julia> link!(n4, n3, 3, 10)

julia> link!(n5, n4, 4, 50)

julia> (n, c) = find_mincost(n5);

julia> (n === n3, c)
(true, 10)
```
