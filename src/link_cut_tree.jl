mutable struct LinkCutTreeNode{T, U, V <: Real}
    label::T # label for node
    edge_label::Union{U, Nothing} # label for edge

    # Splay tree structure of path
    left::Union{LinkCutTreeNode{T, U, V}, Nothing}
    right::Union{LinkCutTreeNode{T, U, V}, Nothing}
    parent::Union{LinkCutTreeNode{T, U, V}, Nothing}

    # Structure of path partition
    path_parent::Union{LinkCutTreeNode{T, U, V}, Nothing}

    # Cost for node v is the cost for the edge from v to its parent in the represented tree

    # mincost(v) = min cost(w) for w in subtree (of splay tree) rooted in v
    delta_cost::V # cost(v) - mincost(v)
    delta_min::V # mincost(v) if v.parent === nothing, mincost(v) - mincost(v.parent) otherwise

    LinkCutTreeNode{T, U, V}(label::T) where {T, U, V <: Real} = new{T, U, V}(label, nothing, nothing, nothing, nothing, nothing,  zero(V), typemax(V))
end


function _add_costs(x::T, y::T) where {T <: Real}
    if x != typemax(T) && y != typemax(T)
        return x + y
    else
        return typemax(T)
    end
end

function _subtract_costs(x::T, y::T) where {T <: Real}
    if x != typemax(T) && y != typemax(T)
        return x - y
    elseif x == typemax(T) && y != typemax(T)
        return typemax(T)
    elseif x == typemax(T) && y == typemax(T)
        return zero(T)
    else
        throw(ErrorException("Error when subtracting costs"))
    end
end

# v assumed to be splay tree root
# does not update the path_parent field in nodes u, v, w
function _disassemble!(v::LinkCutTreeNode)
    u = v.left
    w = v.right

    mincost_v_old = v.delta_min # v root

    v.delta_min = _add_costs(v.delta_cost, mincost_v_old)
    v.delta_cost = zero(v.delta_cost)

    if u !== nothing
        u.parent = nothing
        v.left = nothing

        u.delta_min = _add_costs(u.delta_min, mincost_v_old)
    end

    if w !== nothing
        w.parent = nothing
        v.right = nothing

        w.delta_min = _add_costs(w.delta_min, mincost_v_old)
    end

    return (u, w)
end

# assumes u, v, w splay tree roots, and that the tree rooted in v contains exactly one node
# does not update the path_parent field in nodes u, v, w
function _assemble!(u::Union{T, Nothing}, v::T, w::Union{T, Nothing}) where {T <: LinkCutTreeNode}
    v.left = u
    v.right = w

    cost_v = v.delta_min # only one node
    mincost = cost_v
    if u !== nothing
        mincost = min(mincost, u.delta_min) # u root
    end
    if w !== nothing
        mincost = min(mincost, w.delta_min) # w root
    end

    if u !== nothing
        u.parent = v
        u.delta_min = _subtract_costs(u.delta_min, mincost)
    end
    if w !== nothing
        w.parent = v
        w.delta_min = _subtract_costs(w.delta_min, mincost)
    end

    v.delta_min = mincost
    v.delta_cost = _subtract_costs(cost_v, mincost)

    return nothing
end

"""
    access!(v)

Update the tree that holds `v` with a "preferred path" from the root to `v`
"""
function access!(v::LinkCutTreeNode)
    splay!(v)

    # remove preferred child
    (vl, vr) = _disassemble!(v)
    _assemble!(vl, v, nothing)
    if vr !== nothing
        vr.path_parent = v
    end

    # walk up
    u = v
    while u.path_parent !== nothing
        w = u.path_parent
        splay!(w)
        # set preferred child
        (wl, wr) = _disassemble!(w)
        _assemble!(wl, w, u)
        if wr !== nothing
            wr.path_parent = w
        end
        u.path_parent = nothing

        u = w
    end

    splay!(v)

    return nothing
end

"""
    link!(v, w, i, c)

Make `w` the parent of `v`, set edge label `i` and (non-negative) edge cost `c`.
Assumes `w` and `v` are nodes in different trees, and that `v` is a root node.
"""
function link!(v::LinkCutTreeNode{T, U, V}, w::LinkCutTreeNode{T, U, V}, i::U, c::V) where {T, U, V <: Real}
    # assumes find_root!(v) !== find_root!(w)

    if (c < zero(V))
        throw(ArgumentError("Edge cost is negative"))
    end

    access!(v)
    if v.left !== nothing
        throw(ArgumentError("First argument must be root of tree"))
    end

    access!(w)
    # Now: v.left === nothing (root), v.right === nothing (accessed)
    # w.path_parent === nothing (accessed)

    v.delta_min = c
    v.delta_cost = zero(c)
    v.edge_label = i

    _assemble!(w, v, nothing)

    return nothing
end

"""
    cut!(v)

Separate `v` from its parent
"""
function cut!(v::LinkCutTreeNode)
    access!(v)
    # Now: v.right === nothing (accessed)

    (w, _) = _disassemble!(v)
    # w.path_parent === nothing (was v's child)

    v.delta_min = typemax(v.delta_min)
    v.delta_cost = zero(v.delta_cost)
    v.edge_label = nothing

    return nothing
end

"""
    find_root(v)

Return the root node of the tree that holds `v`
"""
function find_root(v::LinkCutTreeNode)
    access!(v)
    while v.left !== nothing
        v = v.left
    end
    r = v
    access!(r)
    return r
end

"""
    find_mincost(v)

Return `(w, c)`, where `w` is the node closest to the root such that the edge
from `w` to its parent is of minimum cost, and `c` is the cost of this edge
"""
function find_mincost(v::LinkCutTreeNode)
    access!(v)
    c = v.delta_min
    w = v
    while w.delta_cost != zero(w.delta_cost) || w.left !== nothing && w.left.delta_min == zero(w.delta_min)
        if w.left !== nothing && w.left.delta_min == zero(w.delta_min)
            w = w.left
        else # w.delta_cost > 0
            # since w.delta_cost > 0 we know w.right.delta_min == zero(w.delta_min)
            w = w.right
        end
    end
    access!(w)
    return (w, c)
end

"""
    add_cost!(v, c)

Add `c` to the cost of each edge on the path from `v` to the root
"""
function add_cost!(v::LinkCutTreeNode{T, U, V}, x::V) where {T, U, V <: Real}
    access!(v)

    if v.delta_min == typemax(V)
        return nothing
    end

    #v.delta_min = _add_costs(v.delta_min, x)
    v.delta_min += x

    if (v.delta_min < zero(V))
        throw(ArgumentError("Second parameter too small, edge cost became negative"))
    end

    return nothing
end

"""
    cost(v)

Return the cost of the edge from `v` to its parent, return nothing if `v` is the root of the tree
"""
function cost(v::LinkCutTreeNode)
    access!(v)

    if v.left === nothing
        return nothing
    else
        #return _add_costs(v.delta_cost, v.delta_min)
        return v.delta_cost + v.delta_min
    end
end

"""
    parent(v)

Return the parent of node `v` if it exists, and return nothing if `v` is the root of its tree
"""
function parent(v::LinkCutTreeNode)
    access!(v)

    if v.left === nothing
        return nothing
    else
        u = v.left
        while u.right !== nothing
            u = u.right
        end
        access!(u)
        return u
    end
end

"""
    label(v)

Return the label of node `v`
"""
label(v::LinkCutTreeNode) = v.label

"""
    edge_label(v)

Return the label of the edge from `v` to its parent
"""
edge_label(v::LinkCutTreeNode) = v.edge_label

"""
    make_tree(T, U, V, i)

Construct a tree with one node, set the node's label to `i`
"""
make_tree(T::DataType, U::DataType, V::DataType, i) = LinkCutTreeNode{T, U, V}(i)


function rotate_left!(v::LinkCutTreeNode)

    #       v
    #     /   \
    #    /     w
    #   a    /   \
    #       b     c

    #       w
    #     /   \
    #    v     \
    #  /   \    c
    # a     b

    p = v.parent

    (a, w) = _disassemble!(v)
    (b, c) = _disassemble!(w)

    _assemble!(a, v, b)
    _assemble!(v, w, c)

    if p === nothing
        w.path_parent = v.path_parent
        v.path_parent = nothing
    elseif v === p.left
        p.left = w
    else
        p.right = w
    end
    w.parent = p

    return nothing
end

function rotate_right!(v::LinkCutTreeNode)

    #       v
    #     /   \
    #    u     \
    #  /   \    c
    # a     b

    #       u
    #     /   \
    #    /     v
    #   a    /   \
    #       b     c

    p = v.parent

    (u, c) = _disassemble!(v)
    (a, b) = _disassemble!(u)

    _assemble!(b, v, c)
    _assemble!(a, u, v)

    if p === nothing
        u.path_parent = v.path_parent
        v.path_parent = nothing
    elseif v === p.left
        p.left = u
    else
        p.right = u
    end
    u.parent = p

    return nothing
end

function splay!(v::LinkCutTreeNode)
    while v.parent !== nothing
        p = v.parent
        pp = p.parent

        if pp === nothing
            if p.left === v
                rotate_right!(p)
            else
                rotate_left!(p)
            end
        else
            if v === p.left && p === pp.left
                rotate_right!(pp)
                rotate_right!(p)
            elseif v === p.right && p === pp.right
                rotate_left!(pp)
                rotate_left!(p)
            elseif v === p.right && p === pp.left
                rotate_left!(p)
                rotate_right!(pp)
            else
                rotate_right!(p)
                rotate_left!(pp)
            end
        end
    end

    return nothing
end
