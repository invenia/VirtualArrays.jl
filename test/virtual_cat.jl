facts("virtual_cat is like cat") do
    context("empty parameters") do
        @fact_throws virtual_cat()
        @fact_throws cat()
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
        @fact typeof(test).parameters[3] --> typeof(expected)
    end
end