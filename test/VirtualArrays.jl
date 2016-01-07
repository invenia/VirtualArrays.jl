facts("Creating a VirtualArray") do
    context("no parameters or parametric constructors") do
        @pending test = VirtualArray()
        @pending isempty(test.parents) --> true
    end
    context("no parameters but has parametric constructors") do
        expected = []
        test = VirtualArray{Any, 1}()
        test_2 = VirtualArray{Any, 1}(1)

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

        test = VirtualArray{Int64, 1}(a,b)
        test_2 = VirtualArray{Int64, 1}(1,a,b)

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
        test = VirtualArray{Int64, 1}(a)
        test_2 = VirtualArray{Int64, 1}(1, a)
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
        test = VirtualArray{Int64, 1}(parents...)
        test_2 = VirtualArray{Int64, 1}(1, parents...)

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
        test = VirtualArray{Float64, 2}(a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 dimensional parents") do
        # set up
        len = rand(2:4)

        a = rand(len,len)
        b = rand(len,len)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, 2}(a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
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
        test = VirtualArray{Float64, 2}(parents...)

        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("1 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:8) # no larger than 8
        len = rand(1:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)

        expected = cat(1, a)
        test = VirtualArray{Float64, num_dims}(a)

        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("2 multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_dims = rand(3:8) # no larger than 8
        len = rand(1:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        a = rand(dims...)
        b = rand(dims...)

        expected = cat(1, a, b)
        test = VirtualArray{Float64, num_dims}(a, b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact length(test.parents) --> 2
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
    context("multi multi dimensional parents") do
        # set up
        # keep these numbers small because we can run out of memory or get very slow tests
        num_parents = 10# rand(3:10)
        num_dims = rand(3:8) # no larger than 8
        len = rand(1:5) # no larger than 5

        dims = zeros(Int, num_dims) + len

        parents = []
        for i in 1:num_parents
            push!(parents, rand(dims...))
        end

        expected = cat(1, parents...)
        test = VirtualArray{Float64, num_dims}(parents...)

        @fact test.parents --> parents
        @fact length(test.parents) --> num_parents
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @pending test --> expected
        @fact eachindex(test) --> eachindex(expected)
    end
end

facts("Modifying values in a VirtualArray") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        num = rand(1:1000)
        len = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = rand(1:len)

        a = collect(num:num+len)
        b = collect(num:num+len)

        expected = cat(1, a, b)
        test = VirtualArray{Int64, 1}(a,b)

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
        test = VirtualArray{Int64, 1}(a,b)

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
        test = VirtualArray{Int64, 1}(parents...)

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
        test = VirtualArray{Int64, 1}(parents...)

        parents[change_p][change_i] = change_to
        expected = cat(1, parents...)

        @fact test.parents[change_p][change_i] --> change_to
        @fact test[(change_p-1)*len+change_i] --> change_to
        @fact test --> expected

    end
    context("normal case changing multiple VirtualArray element") do

        # set up
        num = rand(1:1000)
        length = rand(1:100)
        num_picked = rand(1:1000)
        index_picked = rand(1:length)

        a = collect(num:num+length)
        b = collect(num:num+length)
        test = VirtualArray{Int64, 1}(a,b)
        test[index_picked] = num_picked
        @fact test[index_picked] --> num_picked
        @fact a[index_picked] --> num_picked
        @fact b[index_picked] --> num + index_picked - 1

    end
end

facts("Errors while using VirtualArray") do
    context("out of bounds indexing on 1 1d array") do
        len = rand(1:100)
        a = rand(len)
        test = VirtualArray{Float64, 1}(a)
        @fact_throws BoundsError test[-1]
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
        test = VirtualArray{Float64, 1}(parents...)
        @fact_throws BoundsError test[-1]
        @fact_throws BoundsError test[len*(num_parents)+1]
    end
    context("out of bounds setting on 1 1d array") do
        len = rand(1:100)
        a = rand(len)
        test = VirtualArray{Float64, 1}(a)
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
        test = VirtualArray{Float64, 1}(parents...)
        @fact_throws BoundsError test[-1] = 1
        @fact_throws BoundsError test[len*(num_parents)+1] = 1
    end
end

function vitual_array_equale_to_array(v::VirtualArray, a::AbstractArray)

    result = false

    if size(v) == size(a) && length(v) == length(a)
        result = true

        for i in 1:length(v)
            if v[i] != a[i]
                result = false
                break
            end
        end

    end

    return result
end

