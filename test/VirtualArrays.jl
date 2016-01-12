
#### CREATING




facts("Creating a VirtualArray") do
    context("no parameters or parametric constructors") do
        @pending test = VirtualArray()
        @pending isempty(test.parents) --> true
    end
    context("no parameters but has parametric constructors") do
        expected = []
        test = VirtualArray{Any, 1, AbstractArray}()
        test_2 = VirtualArray{Any, 1, AbstractArray}(1)

        @fact isempty(test.parents) --> true
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("no parameters but has parametric constructors of specific type") do
        expected = []
        test = VirtualArray{Any, 1, SubArray}()
        test_2 = VirtualArray{Any, 1, SubArray}(1)

        @fact isempty(test.parents) --> true
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("no parameters but has parametric constructors of even more specific type") do
        expected = []
        test = VirtualArray{Any, 1, SubArray{Int, 27}}()
        test_2 = VirtualArray{Any, 1, SubArray{Int, 27}}(1)

        @fact isempty(test.parents) --> true
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("normal case") do
        # set up
        num = rand(1:1000)
        len = rand(1:100)

        a = collect(num:num+len)
        b = collect(num:num+len)
        expected = cat(1,a,b)

        test = VirtualArray{Int64, 1, AbstractArray}(a,b)
        test_2 = VirtualArray{Int64, 1, AbstractArray}(1,a,b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("normal case with specific parametric constructors") do
        # set up
        num = rand(1:1000)
        len = rand(1:100)

        a = collect(num:num+len)
        b = collect(num:num+len)
        expected = cat(1,a,b)

        test = VirtualArray{Int64, 1, Array{Int, 1}}(a,b)
        test_2 = VirtualArray{Int64, 1, Array{Int, 1}}(1,a,b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("one parent") do
        a = collect(1:9)
        test = VirtualArray{Int64, 1, AbstractArray}(a)
        test_2 = VirtualArray{Int64, 1, AbstractArray}(1, a)
        expected = cat(1,a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multiple parent") do
        # set up
        num = rand(1:1000)
        num_parents = rand(3:10)
        len = rand(1:100)

        parents = []
        for i in 1:num_parents
            push!(parents, collect(num:num+len-1))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Int64, 1, AbstractArray}(parents...)
        test_2 = VirtualArray{Int64, 1, AbstractArray}(1, parents...)

        @fact test.parents --> parents
        @fact length(test.parents) --> num_parents
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> test_2
        @fact eachindex(test) --> eachindex(expected)
    end
    context("1 2 dimensional parent") do
        # set up
        len = rand(2:4)

        a = rand(len,len)

        expected = cat(1, a)
        test = VirtualArray{Float64, 2, AbstractArray}(a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 dimensional parents") do
        # set up
        len = rand(2:4)

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multiple 2 dimensional parents") do
        # set up
        num_parents = rand(3:10)
        len = rand(1:100)

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len,len))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Float64, 2, AbstractArray}(parents...)

        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("1 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)

        expected = cat(1, a)
        test = VirtualArray{Float64, num_dims, AbstractArray}(a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multi multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(parents...)

        @fact test.parents --> parents
        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
end

facts("Creating VirtualArrays and expanding on different dimensions") do
    context("1 2 dimensional parent") do
        # set up
        len = rand(2:4)
        expanded_dim = 2

        a = rand(len,len)

        expected = cat(expanded_dim, a)
        test = VirtualArray{Float64, 2, AbstractArray}(expanded_dim, a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 dimensional parents") do
        # set up
        len = rand(2:4)
        expanded_dim = 2

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(expanded_dim, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(expanded_dim, a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multiple 2 dimensional parents") do
        # set up
        num_parents = rand(3:10)
        len = rand(1:100)
        expanded_dim = 2

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len,len))
        end

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, 2, AbstractArray}(expanded_dim, parents...)

        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("1 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)

        expected = cat(expanded_dim, a)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(expanded_dim, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multi multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end

    context("creating an 1 d VirtualArray with 1 d parents of different lengths") do
        # set up
        num_dims = 1
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 1

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("creating an 2 d VirtualArray with 2 d parents of different lengths") do
        # set up
        num_dims = 2
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:21) # no larger than 5
        expanded_dim = 2

        a = rand(len, len)
        b = rand(len, len_2)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("creating an 2 d VirtualArray with 2 d parents of different heights") do
        # set up
        num_dims = 2
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:21) # no larger than 5
        expanded_dim = 1

        a = rand(len, len)
        b = rand(len_2, len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end

    context("creating an 2 d VirtualArray with 1 d parents") do
        # set up
        num_dims = 2
        len = rand(2:10) # no larger than 5
        expanded_dim = 2

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("creating an 3> d VirtualArray with 1 d parents") do
        # set up
        num_dims = rand(3:10)
        len = rand(2:10) # no larger than 5
        expanded_dim = num_dims

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        @fact test.parents --> parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
end




#### MODIFYING




facts("Modifying values in a VirtualArray with 1 d arrays") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        num = rand(1:1000)
        len = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = collect(num:num+len)
        b = collect(num:num+len)

        expected = cat(1, a, b)
        test = VirtualArray{Int64, 1, AbstractArray}(a,b)

        test[index_picked] = num_picked
        expected[index_picked] = num_picked

        @fact test[index_picked] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact b[index_picked] --> num + index_picked - 1
        @fact test --> expected

    end
    context("normal case changing one parent element in the first parent") do

        # set up
        num = rand(1:1000)
        len = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = collect(num:num+len)
        b = collect(num:num+len)

        expected = cat(1, a, b)
        test = VirtualArray{Int64, 1, AbstractArray}(a,b)

        a[index_picked] = num_picked
        expected = cat(1, a, b)

        @fact test[index_picked] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact b[index_picked] --> num + index_picked - 1
        @fact test --> expected

    end
    context("normal case changing one VirtualArray element in the any parent") do

        # set up
        num = rand(1:1000)
        num_parents = rand(3:10)
        len = rand(1:10)
        change_p = rand(3:num_parents)
        change_i = rand(1:len)
        change_to = rand(1:10)

        parents = []
        for i in 1:num_parents
            push!(parents, collect(num:num+len-1))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Int64, 1, AbstractArray}(parents...)

        test[(change_p-1)*len+change_i] = change_to
        expected[(change_p-1)*len+change_i] = change_to

        @fact test[(change_p-1)*len+change_i] --> change_to
        @fact test.parents[change_p][change_i] --> change_to
        @fact test --> expected

    end
    context("normal case changing one element in the any parent") do

        # set up
        num = rand(1:1000)
        num_parents = rand(3:10)
        len = rand(1:100)
        change_p = rand(3:num_parents)
        change_i = rand(1:len)
        change_to = rand(1:10)

        parents = []
        for i in 1:num_parents
            push!(parents, collect(num:num+len-1))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Int64, 1, AbstractArray}(parents...)

        parents[change_p][change_i] = change_to
        expected = cat(1, parents...)

        @fact test.parents[change_p][change_i] --> change_to
        @fact test[(change_p-1)*len+change_i] --> change_to
        @fact test --> expected

    end
end

facts("Modifying values in a VirtualArray with 2 d arrays") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        len = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = [rand(1:len),rand(1:len)]

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(a,b)

        test[index_picked...] = num_picked
        expected[index_picked...] = num_picked

        @fact test[index_picked...] --> num_picked
        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one parent element in the first parent") do

        # set up
        len = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = [rand(1:len),rand(1:len)]

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(a,b)

        a[index_picked...] = num_picked
        expected = cat(1, a, b)

        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one VirtualArray element in the any parent") do

        # set up
        num_parents = rand(3:10)
        len = rand(1:10)
        change_p = rand(3:num_parents)
        change_i = [rand(1:len),rand(1:len)]
        change_to = rand(1:10)
        combined_i = [(change_p-1)*len+change_i[1],change_i[2]]

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len,len))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Float64, 2, AbstractArray}(parents...)


        test[combined_i...] = change_to
        expected[combined_i...] = change_to

        @fact test[combined_i...] --> change_to
        @fact test.parents[change_p][change_i...] --> change_to
        @fact test --> expected

    end
    context("normal case changing one element in the any parent") do

        # set up
        num_parents = rand(3:10)
        len = rand(1:100)
        change_p = rand(3:num_parents)
        change_i = [rand(1:len),rand(1:len)]
        change_to = rand(1:10)
        combined_i = [(change_p-1)*len+change_i[1],change_i[2]]

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len,len))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Float64, 2, AbstractArray}(parents...)

        parents[change_p][change_i...] = change_to
        expected = cat(1, parents...)

        @fact test.parents[change_p][change_i...] --> change_to
        @fact test[combined_i...] --> change_to
        @fact test --> expected

    end
end

facts("Modifying values in a VirtualArray with mulit d arrays") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        num_picked = rand(1:1000)
        index_picked = []
        for i in 1:num_dims
            push!(index_picked, rand(1:len))
        end

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(a,b)

        test[index_picked...] = num_picked
        expected[index_picked...] = num_picked

        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one parent element in the first parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        num_picked = rand(1:1000)
        index_picked = []
        for i in 1:num_dims
            push!(index_picked, rand(1:len))
        end

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(a,b)

        a[index_picked...] = num_picked
        expected = cat(1, a, b)

        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one VirtualArray element in the any parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end
        change_i = []
        for i in 1:num_dims
            push!(change_i, rand(1:len))
        end
        change_p = rand(3:num_parents)
        change_to = rand(1:10)
        combined_i = [(change_p-1)*len+change_i[1],change_i[2:end]...]

        expected = cat(1, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(parents...)

        test[combined_i...] = change_to
        expected[combined_i...] = change_to

        @fact test[combined_i...] --> change_to
        @fact test.parents[change_p][change_i...] --> change_to
        @fact test --> expected

    end
    context("normal case changing one element in the any parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end
        change_i = []
        for i in 1:num_dims
            push!(change_i, rand(1:len))
        end
        change_p = rand(3:num_parents)
        change_to = rand(1:10)
        combined_i = [(change_p-1)*len+change_i[1],change_i[2:end]...]

        expected = cat(1, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(parents...)

        parents[change_p][change_i...] = change_to
        expected = cat(1, parents...)

        @fact test.parents[change_p][change_i...] --> change_to
        @fact test[combined_i...] --> change_to
        @fact test --> expected

    end
end

facts("Modifying values in a VirtualArray with mulit d arrays and expand in different dimensions") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        num_picked = rand(1:1000)
        index_picked = []
        for i in 1:num_dims
            push!(index_picked, rand(1:len))
        end

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(expanded_dim, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, a,b)

        test[index_picked...] = num_picked
        expected[index_picked...] = num_picked

        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one parent element in the first parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        num_picked = rand(1:1000)
        index_picked = []
        for i in 1:num_dims
            push!(index_picked, rand(1:len))
        end

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(expanded_dim, a, b)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, a,b)

        a[index_picked...] = num_picked
        expected = cat(expanded_dim, a, b)

        @fact test[index_picked...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact test --> expected

    end
    context("normal case changing one VirtualArray element in the any parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end
        change_i = []
        for i in 1:num_dims
            push!(change_i, rand(1:len))
        end
        change_p = rand(3:num_parents)
        change_to = rand(1:10)
        combined_i = [
                change_i[1:expanded_dim-1]...,
                (change_p-1)*len+change_i[expanded_dim],
                change_i[expanded_dim+1:end]...
            ]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        test[combined_i...] = change_to
        expected[combined_i...] = change_to

        @fact test[combined_i...] --> change_to
        @fact test.parents[change_p][change_i...] --> change_to
        @fact test --> expected

    end
    context("normal case changing one element in the any parent") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end
        change_i = []
        for i in 1:num_dims
            push!(change_i, rand(1:len))
        end
        change_p = rand(3:num_parents)
        change_to = rand(1:10)
        combined_i = [
                change_i[1:expanded_dim-1]...,
                (change_p-1)*len+change_i[expanded_dim],
                change_i[expanded_dim+1:end]...
            ]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        parents[change_p][change_i...] = change_to
        expected = cat(expanded_dim, parents...)

        @fact test.parents[change_p][change_i...] --> change_to
        @fact test[combined_i...] --> change_to
        @fact test --> expected

    end
end

facts("Accessing VirtualArray values oddly") do
    context("accessing the element with a bunch of 1's padded on") do

        # set up
        len = rand(1:50)
        num_picked = rand(1:1000)
        index_picked = [rand(1:len),rand(1:len)]
        oness = ones(Int, rand(1:20))

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(a,b)

        test[index_picked...] = num_picked
        expected[index_picked...] = num_picked

        @fact test[index_picked...] --> num_picked
        @fact test[index_picked..., oness...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact a[index_picked..., oness...] --> num_picked
        @fact test --> expected

    end
    context("setting the element with a bunch of 1's padded on") do

        # set up
        len = rand(1:50)
        num_picked = rand(1:1000)
        index_picked = [rand(1:len),rand(1:len)]
        oness = ones(Int, rand(1:20))

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2, AbstractArray}(a,b)

        test[index_picked..., oness...] = num_picked
        expected[index_picked..., oness...] = num_picked

        @fact test[index_picked...] --> num_picked
        @fact test[index_picked..., oness...] --> num_picked
        @fact a[index_picked...] --> num_picked
        @fact a[index_picked..., oness...] --> num_picked
        @fact test --> expected

    end
    context("accessing a multi d VirtualArray like a 1 d array when expanded on dimension 1") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = 1

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        change_to = rand(1:10)
        change_i = rand(1:length(expected))

        test[change_i] = change_to
        expected[change_i] = change_to

        @fact test --> expected

    end
    context("accessing a multi d VirtualArray like a 1 d array when expanded on dimension 2") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = 2

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        change_to = rand(1:10)
        change_i = rand(1:length(expected))

        test[change_i] = change_to
        expected[change_i] = change_to

        @fact test --> expected

    end
    context("accessing a multi d VirtualArray like a 1 d array when expanded on dimension above 2") do

        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = rand(3:10) # no larger than 10
        num_dims = rand(3:6) # no larger than 6
        len = rand(2:5) # no larger than 5
        expanded_dim = rand(3:num_dims)

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        change_to = rand(1:10)
        change_i = rand(1:length(expected))

        test[change_i] = change_to
        expected[change_i] = change_to

        @fact test --> expected

    end
end



facts("Modifying values in a 1 d VirtualArray with 1 d arrays of different lengths") do
    context("modifying a value in the first parent from VirtualArray") do
        # set up
        num_dims = 1
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 1
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        test[index_picked] = num_picked
        expected[index_picked] = num_picked

        @fact test[index_picked] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying a value in the second parent from VirtualArray") do
        # set up
        num_dims = 1
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 1
        num_picked = rand(1:1000)
        index_picked = rand(1:len_2)

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        test[index_picked + len] = num_picked
        expected[index_picked + len] = num_picked

        @fact test[index_picked + len] --> num_picked
        @fact b[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying a value in the first parent from the parent") do
        # set up
        num_dims = 1
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 1
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        a[index_picked] = num_picked
        expected = cat(expanded_dim, parents...)

        @fact test[index_picked] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying a value in the second parent from the parent") do
        # set up
        num_dims = 1
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 1
        num_picked = rand(1:1000)
        index_picked = rand(1:len_2)

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        b[index_picked] = num_picked
        expected = cat(expanded_dim, parents...)

        @fact test[index_picked + len] --> num_picked
        @fact b[index_picked] --> num_picked
        @fact test --> expected
    end
end


facts("modifying values of m d VirtualArrays with n d parents") do
    context("modifying the value in the first parent from VirtualArray") do
        # set up
        num_dims = 2
        len = rand(2:10) # no larger than 5
        expanded_dim = 2
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        test[index_picked, 1] = num_picked
        expected[index_picked, 1] = num_picked

        @fact test[index_picked, 1] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying the value in the second parent from VirtualArray") do
        # set up
        num_dims = 2
        len = rand(2:10) # no larger than 5
        expanded_dim = 2
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        test[index_picked, 2] = num_picked
        expected[index_picked, 2] = num_picked

        @fact test[index_picked, 2] --> num_picked
        @fact b[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying the value in the first parent from the parent") do
        # set up
        num_dims = 2
        len = rand(2:10) # no larger than 5
        expanded_dim = 2
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        expected = cat(expanded_dim, parents...)
        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        a[index_picked] = num_picked
        expected = cat(expanded_dim, parents...)

        @fact test[index_picked, 1] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact test --> expected
    end
    context("modifying the value in the second parent from the parent") do
        # set up
        num_dims = 2
        len = rand(2:10) # no larger than 5
        expanded_dim = 2
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = rand(len)
        b = rand(len)
        parents = Array[a, b]

        test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        b[index_picked] = num_picked
        expected = cat(expanded_dim, parents...)

        @fact test[index_picked, 2] --> num_picked
        @fact b[index_picked] --> num_picked
        @fact test --> expected
    end
end







#### ERRORS





facts("Errors while using VirtualArray") do
    context("out of bounds indexing on 1 1d array") do
        len = rand(1:100)
        a = rand(len)
        test = VirtualArray{Float64, 1, AbstractArray}(a)
        @fact_throws BoundsError test[-1]
        @fact_throws BoundsError test[0]
        @fact_throws BoundsError test[len+1]
    end
    context("out of bounds indexing on multiple 1d arrays") do
        # set up
        num_parents = rand(3:10)
        len = rand(1:100)

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len))
        end
        test = VirtualArray{Float64, 1, AbstractArray}(parents...)
        @fact_throws BoundsError test[-1]
        @fact_throws BoundsError test[len*(num_parents)+1]
    end
    context("out of bounds setting on 1 1d array") do
        len = rand(1:100)
        a = rand(len)
        test = VirtualArray{Float64, 1, AbstractArray}(a)
        @fact_throws BoundsError test[-1] = 1
        @fact_throws BoundsError test[len+1] = 1
    end
    context("out of bounds setting on multiple 1d arrays") do
        # set up
        num_parents = rand(3:10)
        len = rand(1:100)

        parents = []
        for i in 1:num_parents
            push!(parents, rand(len))
        end
        test = VirtualArray{Float64, 1, AbstractArray}(parents...)
        @fact_throws BoundsError test[-1] = 1
        @fact_throws BoundsError test[len*(num_parents)+1] = 1
    end
    context("throw the right type of error when accessing the array wrong") do

        # set up
        a = rand(3,3,3)
        b = rand(3,3,3)

        c = cat(1,a,b)
        test = VirtualArray{Float64, 3, AbstractArray}(1, a, b)

        @fact_throws BoundsError c[6,4,1]
        @fact_throws BoundsError test[6,4,1]

        c_error = 1
        try
            c[6,4,1]
        catch e
            c_error = e
        end

        test_error = 1
        try
            test[6,4,1]
        catch e
            test_error = e
        end

        @fact test_error.a --> c_error.a
        @fact test_error.i --> c_error.i

    end
    context("trying to make an 2 d array of 1 d parents of different sizes") do
        # set up
        num_dims = 2
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:30) # no larger than 5
        expanded_dim = 2

        a = rand(len)
        b = rand(len_2)
        parents = Array[a, b]

        @fact_throws DimensionMismatch expected = cat(expanded_dim, parents...)
        @fact_throws DimensionMismatch test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)

        c_error = 1
        try
            expected = cat(expanded_dim, parents...)
        catch e
            c_error = e
        end

        test_error = 1
        try
            test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)
        catch e
            test_error = e
        end

        @fact contains(c_error.msg, test_error.msg) --> true
    end
    context("creating an 2 d VirtualArray with 2 d parents of different lengths on the wrong dimension") do
        # set up
        num_dims = 2
        len = rand(2:2:20) # no larger than 5
        len_2 = rand(3:2:21) # no larger than 5
        expanded_dim = 1 # to work, this should be 2

        a = rand(len, len)
        b = rand(len, len_2)
        parents = Array[a, b]

        @fact_throws DimensionMismatch expected = cat(expanded_dim, parents...)
        @fact_throws DimensionMismatch test = VirtualArray{Float64, num_dims, AbstractArray}(expanded_dim, parents...)
    end
end
