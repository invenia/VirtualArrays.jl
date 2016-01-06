facts("Creating a VirtualArray") do
    context("no parameters or parametric constructors") do
        @pending test = VirtualArray()
        @pending isempty(test.parents) --> true
    end
    context("no parameters but has parametric constructors") do
        @pending test = VirtualArray{Any, 1, Array{Any,1}}()
        @pending isempty(test.parents) --> true
    end
    context("normal case") do

        # set up
        num = rand(1:1000)
        length = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:length)

        a = collect(num:num+length)
        b = collect(num:num+length)

        test = VirtualArray{Int64, 1, Array{Int64,1}}(a,b)
        @fact test.parent_1 --> a
        @fact test.parent_2 --> b
        @pending test.parents[1] --> a
        @pending test.parents[2] --> b
    end
    context("one parent") do
        a = collect(1:9)
        @pending test = VirtualArray{Int64, 1, Array{Int64,1}}(a)
        @pending test.parents[1] --> test
        @pending length(test.parents) --> 1
    end
end

facts("Modifying values in a VirtualArray") do
    context("normal case changing one VirtualArray element in the first parent") do

        # set up
        num = rand(1:1000)
        length = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:length)

        a = collect(num:num+length)
        b = collect(num:num+length)
        test = VirtualArray{Int64, 1, Array{Int64,1}}(a,b)
        test[index_pciked] = num_pciked
        @fact test[index_pciked] --> num_pciked
        @fact a[index_pciked] --> num_pciked
        @fact b[index_pciked] --> num + index_pciked - 1

    end
    context("normal case changing multiple VirtualArray element") do

        # set up
        num = rand(1:1000)
        length = rand(1:100)
        num_pciked = rand(1:1000)
        index_pciked = rand(1:length)

        a = collect(num:num+length)
        b = collect(num:num+length)
        test = VirtualArray{Int64, 1, Array{Int64,1}}(a,b)
        test[index_pciked] = num_pciked
        @fact test[index_pciked] --> num_pciked
        @fact a[index_pciked] --> num_pciked
        @fact b[index_pciked] --> num + index_pciked - 1

    end
end