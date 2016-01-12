facts("virtual_cat is like cat") do
    context("empty parameters") do
        @fact_throws virtual_cat()
        @fact_throws cat()
    end
    context("concatenating no arrays") do
        expected = cat(1)
        test = virtual_cat(1)

        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact eachindex(test) --> eachindex(expected)
        @fact typeof(test).parameters[1] --> typeof(expected).parameters[1]
        @fact typeof(test).parameters[2] --> typeof(expected).parameters[2]
    end
    context("concatenating one 1 d array") do
        len = rand(1:10)

        a = rand(len)
        expected = cat(1,a)
        test = virtual_cat(1,a)

        @fact test.parents[1] --> a
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact eachindex(test) --> eachindex(expected)
        @fact typeof(test).parameters[1] --> typeof(expected).parameters[1]
        @fact typeof(test).parameters[2] --> typeof(expected).parameters[2]
    end
    context("concatenating two 1 d arrays") do
        len = rand(1:10)

        a = rand(len)
        b = rand(len)
        expected = cat(1,a,b)
        test = virtual_cat(1,a,b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact eachindex(test) --> eachindex(expected)
        @fact typeof(test).parameters[1] --> typeof(expected).parameters[1]
        @fact typeof(test).parameters[2] --> typeof(expected).parameters[2]
    end
end

facts("virtual_vcat is like vcat") do
    context("concatenating two 1 d arrays") do
        len = rand(1:10)

        a = rand(len)
        b = rand(len)
        expected = vcat(a,b)
        test = virtual_vcat(a,b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact eachindex(test) --> eachindex(expected)
        @fact typeof(test).parameters[1] --> typeof(expected).parameters[1]
        @fact typeof(test).parameters[2] --> typeof(expected).parameters[2]
    end
end

facts("virtual_hcat is like hcat") do
    context("concatenating two 1 d arrays") do
        len = rand(1:10)

        a = rand(len)
        b = rand(len)
        expected = hcat(a,b)
        test = virtual_hcat(a,b)

        @fact test.parents[1] --> a
        @fact test.parents[2] --> b
        @fact test --> expected
        @fact length(test) --> length(expected)
        @fact size(test) --> size(expected)
        @fact eachindex(test) --> eachindex(expected)
        @fact typeof(test).parameters[1] --> typeof(expected).parameters[1]
        @fact typeof(test).parameters[2] --> typeof(expected).parameters[2]
    end
end