facts("Creating a VirtualArray") do
    context("no parameters or parametric constructors") do
        @pending test = VirtualArray()
        @pending isempty(test.parents) --> true
    end
    context("no parameters but has parametric constructors") do
        expeted = []
        test = VirtualArray{Any, 1}()
        @fact isempty(test.parents) --> true
        @fact length(test) --> length(expeted)
        @fact size(test) --> size(expeted)
    end
    context("normal case") do
        # set up
        num = rand(1:1000)
        len = rand(1:100)

        a = collect(num:num+len)
        b = collect(num:num+len)
        expected = cat(1,a,b)

        test = VirtualArray{Int64, 1}(a,b)
        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @pending test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
    end
    context("one parent") do
        a = collect(1:9)
        test = VirtualArray{Int64, 1}(a)
        @fact test.parents[1] --> a
        @fact length(test.parents) --> 1
        @fact length(test) --> length(a)
        @fact size(test) --> size(a)
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
        test = VirtualArray{Int64, 1}(parents...)
        @fact test.parents --> parents
        @fact length(test.parents) --> num_parents
    end
    context("2 dimensional parents") do
        # set up
        num = rand(1:1000)
        len = rand(1:100)

        a = rand(len,len)
        b = rand(len,len)

        @pending test = VirtualArray{Int64, 1}(a, b)
        @pending test.parents[1] --> a
        @pending test.parents[1] --> b
        @pending length(test.parents) --> 2
    end
end

facts("Modifying values in a VirtualArray") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        num = rand(1:1000)
        len = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:len)

        a = collect(num:num+len)
        b = collect(num:num+len)
        test = VirtualArray{Int64, 1}(a,b)
        test[index_pciked] = num_pciked
        @fact test[index_pciked] --> num_pciked
        @fact a[index_pciked] --> num_pciked
        @fact b[index_pciked] --> num + index_pciked - 1

    end
    context("normal case changing one parent element in the first parent") do

        # set up
        num = rand(1:1000)
        len = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:len)

        a = collect(num:num+len)
        b = collect(num:num+len)
        test = VirtualArray{Int64, 1}(a,b)
        a[index_pciked] = num_pciked
        @fact test[index_pciked] --> num_pciked
        @fact a[index_pciked] --> num_pciked
        @fact b[index_pciked] --> num + index_pciked - 1

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
        test = VirtualArray{Int64, 1}(parents...)
        test[(change_p-1)*len+change_i] = change_to
        @fact test[(change_p-1)*len+change_i] --> change_to
        @fact test.parents[change_p][change_i] --> change_to

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
        test = VirtualArray{Int64, 1}(parents...)
        test.parents[change_p][change_i] = change_to
        @fact test.parents[change_p][change_i] --> change_to
        @fact test[(change_p-1)*len+change_i] --> change_to

    end
    context("normal case changing multiple VirtualArray element") do

        # set up
        num = rand(1:1000)
        length = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:length)

        a = collect(num:num+length)
        b = collect(num:num+length)
        test = VirtualArray{Int64, 1}(a,b)
        test[index_pciked] = num_pciked
        @fact test[index_pciked] --> num_pciked
        @fact a[index_pciked] --> num_pciked
        @fact b[index_pciked] --> num + index_pciked - 1

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

