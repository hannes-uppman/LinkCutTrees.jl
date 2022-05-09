@testset "LinkCutTrees" begin

    function attach_left!(v::LinkCutTreeNode, w::LinkCutTreeNode)
        w.left = v
        v.parent = w
    end

    function attach_right!(v::LinkCutTreeNode, w::LinkCutTreeNode)
        w.right = v
        v.parent = w
    end

    function set_cost!(v::LinkCutTreeNode, delta_cost, delta_min)
        v.delta_cost = delta_cost
        v.delta_min = delta_min
    end

    get_cost(v::LinkCutTreeNode) = (v.delta_cost, v.delta_min)

    @testset "splay!" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1

            set_cost!(n2, 2, 2)
            set_cost!(n3, 0, 0)
            set_cost!(n4, 0, 1)

            splay!(n2)

            @test n2.path_parent === n1
            @test n2.left == n3
            @test n2.right == n4

            @test get_cost(n2) == (2, 2)
            @test get_cost(n3) == (0, 0)
            @test get_cost(n4) == (0, 1)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n3)
            attach_right!(n6, n3)

            set_cost!(n2, 7, 2)
            set_cost!(n3, 0, 0)
            set_cost!(n4, 0, 0)
            set_cost!(n5, 0, 1)
            set_cost!(n6, 0, 2)

            splay!(n3)

            @test  n3.path_parent === n1
            @test  n3.left === n5
            @test  n3.right === n2
            @test  n2.left === n6
            @test  n2.right === n4

            @test get_cost(n3) == (0, 2)
            @test get_cost(n5) == (0, 1)
            @test get_cost(n2) == (7, 0)
            @test get_cost(n6) == (0, 2)
            @test get_cost(n4) == (0, 0)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n4)
            attach_right!(n6, n4)

            set_cost!(n2, 2, 2)
            set_cost!(n3, 0, 5)
            set_cost!(n4, 0, 0)
            set_cost!(n5, 0, 1)
            set_cost!(n6, 0, 7)

            splay!(n4)

            @test  n4.path_parent === n1
            @test  n4.left === n2
            @test  n4.right === n6
            @test  n2.left === n3
            @test  n2.right === n5

            @test get_cost(n4) == (0, 2)
            @test get_cost(n2) == (1, 1)
            @test get_cost(n6) == (0, 7)
            @test get_cost(n3) == (0, 4)
            @test get_cost(n5) == (0, 0)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n3)
            attach_right!(n6, n3)
            attach_left!(n7, n5)
            attach_right!(n8, n5)

            set_cost!(n2, 7, 2)
            set_cost!(n3, 0, 0)
            set_cost!(n4, 0, 12)
            set_cost!(n5, 6, 2)
            set_cost!(n6, 0, 2)
            set_cost!(n7, 0, 0)
            set_cost!(n8, 0, 1)

            splay!(n5)

            @test  n5.path_parent === n1
            @test  n5.left === n7
            @test  n5.right === n3
            @test  n3.left === n8
            @test  n3.right === n2
            @test  n2.left === n6
            @test  n2.right === n4

            @test get_cost(n5) == (8, 2)
            @test get_cost(n7) == (0, 2)
            @test get_cost(n3) == (0, 0)
            @test get_cost(n8) == (0, 3)
            @test get_cost(n2) == (5, 2)
            @test get_cost(n6) == (0, 0)
            @test get_cost(n4) == (0, 10)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n4)
            attach_right!(n6, n4)
            attach_left!(n7, n5)
            attach_right!(n8, n5)

            set_cost!(n2, 15, 1)
            set_cost!(n3, 0, 3)
            set_cost!(n4, 1, 0)
            set_cost!(n5, 0, 0)
            set_cost!(n6, 0, 6)
            set_cost!(n7, 0, 2)
            set_cost!(n8, 0, 8)

            splay!(n5)

            @test  n5.path_parent === n1
            @test  n5.left === n2
            @test  n5.right === n4
            @test  n2.left === n3
            @test  n2.right === n7
            @test  n4.left === n8
            @test  n4.right === n6

            @test get_cost(n5) == (0, 1)
            @test get_cost(n2) == (13, 2)
            @test get_cost(n4) == (0, 1)
            @test get_cost(n3) == (0, 1)
            @test get_cost(n7) == (0, 0)
            @test get_cost(n8) == (0, 7)
            @test get_cost(n6) == (0, 5)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n3)
            attach_right!(n6, n3)
            attach_left!(n7, n6)
            attach_right!(n8, n6)

            set_cost!(n2, 16, 1)
            set_cost!(n3, 8, 0)
            set_cost!(n4, 0, 1)
            set_cost!(n5, 0, 0)
            set_cost!(n6, 1, 3)
            set_cost!(n7, 0, 0)
            set_cost!(n8, 0, 8)

            splay!(n6)

            @test  n6.path_parent === n1
            @test  n6.left === n3
            @test  n6.right === n2
            @test  n3.left === n5
            @test  n3.right === n7
            @test  n2.left === n8
            @test  n2.right === n4

            @test get_cost(n6) == (4, 1)
            @test get_cost(n3) == (8, 0)
            @test get_cost(n2) == (15, 1)
            @test get_cost(n5) == (0, 0)
            @test get_cost(n7) == (0, 3)
            @test get_cost(n8) == (0, 10)
            @test get_cost(n4) == (0, 0)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n4)
            attach_right!(n6, n4)
            attach_left!(n7, n6)
            attach_right!(n8, n6)

            set_cost!(n2, 30, 2)
            set_cost!(n3, 0, 7)
            set_cost!(n4, 25, 0)
            set_cost!(n5, 0, 48)
            set_cost!(n6, 0, 0)
            set_cost!(n7, 0, 2)
            set_cost!(n8, 0, 68)

            splay!(n6)

            @test  n6.path_parent === n1
            @test  n6.left === n4
            @test  n6.right === n8
            @test  n4.left === n2
            @test  n4.right === n7
            @test  n2.left === n3
            @test  n2.right === n5

            @test get_cost(n6) == (0, 2)
            @test get_cost(n4) == (23, 2)
            @test get_cost(n8) == (0, 68)
            @test get_cost(n2) == (23, 5)
            @test get_cost(n7) == (0, 0)
            @test get_cost(n3) == (0, 0)
            @test get_cost(n5) == (0, 41)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)
            n9 = make_tree(Int, Nothing, Int, 9)
            n10 = make_tree(Int, Nothing, Int, 10)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n3)
            attach_right!(n6, n3)
            attach_left!(n7, n5)
            attach_right!(n8, n5)
            attach_left!(n9, n7)
            attach_right!(n10, n7)

            set_cost!(n2, 1, 1)
            set_cost!(n3, 3, 0)
            set_cost!(n4, 0, 2)
            set_cost!(n5, 0, 0)
            set_cost!(n6, 0, 8)
            set_cost!(n7, 5, 1)
            set_cost!(n8, 0, 16)
            set_cost!(n9, 0, 4)
            set_cost!(n10, 0, 0)

            splay!(n7)

            @test  n7.path_parent === n1
            @test  n7.left === n9
            @test  n7.right === n2
            @test  n2.left === n5
            @test  n2.right === n4
            @test  n5.left === n10
            @test  n5.right === n3
            @test  n3.left === n8
            @test  n3.right === n6

            @test get_cost(n7) == (6, 1)
            @test get_cost(n9) == (0, 5)
            @test get_cost(n2) == (1, 0)
            @test get_cost(n5) == (0, 0)
            @test get_cost(n4) == (0, 2)
            @test get_cost(n10) == (0, 1)
            @test get_cost(n3) == (0, 3)
            @test get_cost(n8) == (0, 13)
            @test get_cost(n6) == (0, 5)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)
            n8 = make_tree(Int, Nothing, Int, 8)
            n9 = make_tree(Int, Nothing, Int, 9)
            n10 = make_tree(Int, Nothing, Int, 10)

            attach_left!(n3, n2)
            attach_right!(n4, n2)
            n2.path_parent = n1
            attach_left!(n5, n4)
            attach_right!(n6, n4)
            attach_left!(n7, n6)
            attach_right!(n8, n6)
            attach_left!(n9, n8)
            attach_right!(n10, n8)

            set_cost!(n2, 8, 1)
            set_cost!(n3, 0, 4)
            set_cost!(n4, 2, 0)
            set_cost!(n5, 0, 8)
            set_cost!(n6, 2, 0)
            set_cost!(n7, 0, 11)
            set_cost!(n8, 0, 0)
            set_cost!(n9, 0, 9)
            set_cost!(n10, 0, 4)

            splay!(n8)

            @test  n8.path_parent === n1
            @test  n8.left === n2
            @test  n8.right === n10
            @test  n2.left === n3
            @test  n2.right === n6
            @test  n6.left === n4
            @test  n6.right === n9
            @test  n4.left === n5
            @test  n4.right === n7

            @test get_cost(n8) == (0, 1)
            @test get_cost(n2) == (6, 2)
            @test get_cost(n10) == (0, 4)
            @test get_cost(n3) == (0, 2)
            @test get_cost(n6) == (0, 0)
            @test get_cost(n4) == (0, 0)
            @test get_cost(n9) == (0, 7)
            @test get_cost(n5) == (0, 6)
            @test get_cost(n7) == (0, 9)
        end
    end

    @testset "access!" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)

            n2.path_parent = n1
            n3.path_parent = n1
            n4.path_parent = n1
            n5.path_parent = n2
            n6.path_parent = n3

            access!(n5)

            @test n5.parent === nothing
            @test n5.path_parent === nothing
            @test n5.right === nothing
            @test n5.left === n2
            @test n2.parent === n5
            @test n2.left === n1
            @test n1.parent === n2
            @test n3.path_parent === n1
            @test n4.path_parent === n1
            @test n6.path_parent === n3
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)

            n2.path_parent = n1
            n3.path_parent = n1
            n4.path_parent = n1
            n5.path_parent = n2
            n6.path_parent = n3

            access!(n2)

            @test n2.parent === nothing
            @test n2.path_parent === nothing
            @test n2.right === nothing
            @test n2.left === n1
            @test n1.parent === n2
            @test n5.path_parent === n2
            @test n3.path_parent === n1
            @test n4.path_parent === n1
            @test n6.path_parent === n3
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)
            n6 = make_tree(Int, Nothing, Int, 6)
            n7 = make_tree(Int, Nothing, Int, 7)

            n2.path_parent = n1
            attach_left!(n1, n3)
            attach_right!(n6, n3)
            n5.path_parent = n2
            n7.path_parent = n1
            attach_left!(n4, n7)

            access!(n5)

            @test n5.parent === nothing
            @test n5.path_parent === nothing
            @test n5.left === n2
            @test n5.right === nothing
            @test n2.left === n1
            @test n3.path_parent === n1
            @test n3.right === n6
            @test n7.path_parent === n1
            @test n7.left === n4
        end
    end

    @testset "link!" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)

            link!(n2, n1, nothing, 1)

            @test n2.left === n1
            @test n1.parent === n2
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)

            n2.path_parent = n1

            @test_throws ArgumentError link!(n2, n1, nothing, 1)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)

            n2.path_parent = n1

            @test_throws ArgumentError link!(n1, n2, nothing, -1)
        end
    end

    @testset "cut!" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)

            cut!(n1)

            @test  n1.path_parent === nothing
            @test  n1.parent === nothing
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)

            attach_left!(n1, n2)

            cut!(n2)

            @test  n2.path_parent === nothing
            @test  n2.parent === nothing
        end
    end

    @testset "find_root" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)

            r = find_root(n1)

            @test r === n1
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)

            attach_left!(n2, n1)
            attach_left!(n3, n2)

            r = find_root(n1)

            @test r === n3
        end
    end

    @testset "find_mincost" begin
        begin
            n1 = make_tree(Int, Int, Int, 1)
            n2 = make_tree(Int, Int, Int, 2)
            n3 = make_tree(Int, Int, Int, 3)
            n4 = make_tree(Int, Int, Int, 4)
            n5 = make_tree(Int, Int, Int, 5)

            link!(n2, n1, 1, 100)
            link!(n3, n2, 2, 10)
            link!(n4, n3, 3, 10)
            link!(n5, n4, 4, 50)

            (n, c) = find_mincost(n5)

            @test n === n3
            @test c == 10
        end
    end

    @testset "add_cost!" begin
        begin
            n1 = make_tree(Int, Int, Int, 1)
            n2 = make_tree(Int, Int, Int, 2)
            n3 = make_tree(Int, Int, Int, 3)
            n4 = make_tree(Int, Int, Int, 4)
            n5 = make_tree(Int, Int, Int, 5)

            link!(n2, n1, 1, 100)
            link!(n3, n2, 2, 10)
            link!(n4, n3, 3, 10)
            link!(n5, n4, 4, 50)

            add_cost!(n5, -10)

            (n, c) = find_mincost(n5)

            @test n === n3
            @test c == 0

            add_cost!(n5, 100)

            (n, c) = find_mincost(n5)

            @test n === n3
            @test c == 100
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)

            link!(n2, n1, nothing, 100)

            @test_throws ArgumentError add_cost!(n2, -101)
        end

        begin
            n1 = make_tree(Int, Nothing, Int, 1)

            add_cost!(n1, 100)

            @test n1.delta_min == typemax(Int)
            @test n1.delta_cost == 0
        end
    end

    @testset "cost" begin
        begin
            n1 = make_tree(Int, Int, Int, 1)
            n2 = make_tree(Int, Int, Int, 2)
            n3 = make_tree(Int, Int, Int, 3)
            n4 = make_tree(Int, Int, Int, 4)
            n5 = make_tree(Int, Int, Int, 5)

            link!(n2, n1, 1, 100)
            link!(n3, n2, 2, 200)
            link!(n4, n3, 3, 200)
            link!(n5, n4, 4, 50)

            @test cost(n1) === nothing
            @test cost(n2) == 100
            @test cost(n3) == 200
            @test cost(n4) == 200
            @test cost(n5) == 50
        end
    end

    @testset "parent" begin
        begin
            n1 = make_tree(Int, Nothing, Int, 1)
            n2 = make_tree(Int, Nothing, Int, 2)
            n3 = make_tree(Int, Nothing, Int, 3)
            n4 = make_tree(Int, Nothing, Int, 4)
            n5 = make_tree(Int, Nothing, Int, 5)

            attach_left!(n2, n1)
            attach_right!(n3, n1)
            attach_left!(n4, n2)
            attach_right!(n5, n2)

            @test parent(n1) === n5
            @test parent(n2) === n4
            @test parent(n3) === n1
            @test parent(n5) === n2
            @test parent(n4) === nothing
        end
    end

    @testset "label, edge_label" begin
        begin
            n1 = make_tree(Int, Int, Int, 1)
            n2 = make_tree(Int, Int, Int, 2)

            link!(n2, n1, 1, 100)

            @test label(n1) == 1
            @test label(n2) == 2
            @test edge_label(n2) == 1
            @test edge_label(n1) === nothing
        end
    end
end
