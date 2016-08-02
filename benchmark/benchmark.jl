using Benchmark
using VirtualArrays

function print_seperator(file::IOStream, name::AbstractString)
    seperator = "################################################################################"
    println(file)
    println(file, seperator)
    println(file, "# ", name)
    println(file, seperator)
    println(file)
end

open(joinpath(dirname(@__FILE__), "benchmark_result"), "w") do benchmark_file
    num_parents = 10
    len = 100
    num_test = 100
    last = len * num_parents
    half = div(last, 2)
    half_plus_1 = half + 1

    parents = []
    for i in 1:num_parents
        push!(parents, rand(Int64, len))
    end

    print_seperator(benchmark_file, "constructor")

    virtual_cat_bench() = virtual_cat(1, parents...)
    virtual_vcat_bench() = virtual_vcat(parents...)
    virtual_hcat_bench() = virtual_hcat(parents...)
    constructor_1() = VirtualArray{Int64, 1}(parents...)
    constructor_2() = VirtualArray{Int64, 1}(1, parents...)
    constructor_3() = VirtualArray{Int64, 2}(1, parents...)
    constructor_4() = VirtualArray{Int64, 2}(2, parents...)
    cat_bench() = cat(1, parents...)


    println(benchmark_file, benchmark(virtual_cat_bench, "virtual_cat", "virtual_cat(1, parents...)", num_test))
    println(benchmark_file, benchmark(virtual_vcat_bench, "virtual_vcat", "virtual_vcat(parents...)", num_test))
    println(benchmark_file, benchmark(virtual_hcat_bench, "virtual_hcat", "virtual_hcat(parents...)", num_test))
    println(benchmark_file, benchmark(constructor_1, "constructor_1", "VirtualArray{Int64, 1}(parents...)", num_test))
    println(benchmark_file, benchmark(constructor_2, "constructor_2", "VirtualArray{Int64, 1}(1, parents...)", num_test))
    println(benchmark_file, benchmark(constructor_3, "constructor_3", "VirtualArray{Int64, 1}(1, parents...)", num_test))
    println(benchmark_file, benchmark(constructor_4, "constructor_4", "VirtualArray{Int64, 2}(2, parents...)", num_test))
    println(benchmark_file, compare([virtual_cat_bench, virtual_vcat_bench, virtual_hcat_bench, constructor_1, constructor_2, constructor_3, constructor_4, cat_bench], num_test))
    v = VirtualArray{Int64, 1}(1, parents...)
    n = cat(1, parents...)

    print_seperator(benchmark_file, "getindex")

    get_index_virtual_bench1() = v[1]
    get_index_virtual_bench2() = v[last]
    get_index_virtual_bench3() = v[end]
    get_index_normal_bench1() = n[1]
    get_index_normal_bench2() = n[last]
    get_index_normal_bench3() = n[end]

    println(benchmark_file, benchmark(get_index_virtual_bench1, "getting first index", "v[1]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_bench2, "getting last index", "v[last]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_bench3, "getting last index with end", "v[end]", num_test))
    println(benchmark_file, benchmark(get_index_normal_bench1, "getting from normal array first index", "n[1]", num_test))
    println(benchmark_file, benchmark(get_index_normal_bench2, "getting from normal array last index", "n[last]", num_test))
    println(benchmark_file, benchmark(get_index_normal_bench3, "getting from normal array last index with end", "n[end]", num_test))
    println(benchmark_file, compare([get_index_virtual_bench1, get_index_virtual_bench2, get_index_virtual_bench3, get_index_normal_bench1, get_index_normal_bench2, get_index_normal_bench3], num_test))

    print_seperator(benchmark_file, "ranged getindex")

    get_index_virtual_small_start_bench() = v[1:1]
    get_index_virtual_small_end_bench() =   v[last:last]
    get_index_virtual_front_half_bench() =  v[1:half]
    get_index_virtual_end_half_bench() =    v[half_plus_1:last]
    get_index_virtual_entire_bench1() =     v[1:last]
    get_index_virtual_entire_bench2() =     v[:]
    get_index_normal_small_start_bench() =  n[1:1]
    get_index_normal_small_end_bench() =    n[last:last]
    get_index_normal_front_half_bench() =   n[1:half]
    get_index_normal_end_half_bench() =     n[half_plus_1:last]
    get_index_normal_entire_bench1() =      n[1:last]
    get_index_normal_entire_bench2() =      n[:]

    println(benchmark_file, benchmark(get_index_virtual_small_start_bench, "getting range from virtual first index", "v[1:1]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_small_end_bench, "getting range from virtual last index", "v[last:last]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_front_half_bench, "getting range from virtual first half", "v[1:half]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_end_half_bench, "getting range from virtual last half", "v[half_plus_1:last]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_entire_bench1, "getting range from virtual whole with number", "v[1:last]", num_test))
    println(benchmark_file, benchmark(get_index_virtual_entire_bench2, "getting range from virtual whole with colon", "v[:]", num_test))
    println(benchmark_file, benchmark(get_index_normal_small_start_bench, "getting range from normal first index", "n[1:1]", num_test))
    println(benchmark_file, benchmark(get_index_normal_small_end_bench, "getting range from normal last index", "n[last:last]", num_test))
    println(benchmark_file, benchmark(get_index_normal_front_half_bench, "getting range from normal first half", "n[1:half]", num_test))
    println(benchmark_file, benchmark(get_index_normal_end_half_bench, "getting range from normal last half", "n[half_plus_1:last]", num_test))
    println(benchmark_file, benchmark(get_index_normal_entire_bench1, "getting range from normal whole with number", "n[1:last]", num_test))
    println(benchmark_file, benchmark(get_index_normal_entire_bench2, "getting range from normal whole with colon", "n[:]", num_test))
    println(benchmark_file, compare(
        [
            get_index_virtual_small_start_bench, get_index_virtual_small_end_bench,
            get_index_virtual_front_half_bench, get_index_virtual_end_half_bench,
            get_index_virtual_entire_bench1, get_index_virtual_entire_bench2,
            get_index_normal_small_start_bench, get_index_normal_small_end_bench,
            get_index_normal_front_half_bench, get_index_normal_end_half_bench,
            get_index_normal_entire_bench1, get_index_normal_entire_bench2
        ], num_test))

    print_seperator(benchmark_file, "setindex")

    set_index_virtual_bench1() = v[1] = 1
    set_index_virtual_bench2() = v[last] = 1
    set_index_virtual_bench3() = v[end] = 1
    set_index_normal_bench1() = n[1] = 1
    set_index_normal_bench2() = n[last] = 1
    set_index_normal_bench3() = n[end] = 1

    println(benchmark_file, benchmark(set_index_virtual_bench1, "setting first index", "v[1] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_bench2, "setting last index", "v[last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_bench3, "setting last index with end", "v[end] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_bench1, "setting from normal array first index", "n[1] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_bench2, "setting from normal array last index", "n[last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_bench3, "setting from normal array last index with end", "n[end] = 1", num_test))
    println(benchmark_file, compare([set_index_virtual_bench1, set_index_virtual_bench2, set_index_virtual_bench3, set_index_normal_bench1, set_index_normal_bench2, set_index_normal_bench3], num_test))

    print_seperator(benchmark_file, "ranged setindex")

    set_index_virtual_small_start_bench() = v[1:1] = 1
    set_index_virtual_small_end_bench() =   v[last:last] = 1
    set_index_virtual_front_half_bench() =  v[1:half] = 1
    set_index_virtual_end_half_bench() =    v[half_plus_1:last] = 1
    set_index_virtual_entire_bench1() =     v[1:last] = 1
    set_index_virtual_entire_bench2() =     v[:] = 1
    set_index_normal_small_start_bench() =  n[1:1] = 1
    set_index_normal_small_end_bench() =    n[last:last] = 1
    set_index_normal_front_half_bench() =   n[1:half] = 1
    set_index_normal_end_half_bench() =     n[half_plus_1:last] = 1
    set_index_normal_entire_bench1() =      n[1:last] = 1
    set_index_normal_entire_bench2() =      n[:] = 1

    println(benchmark_file, benchmark(set_index_virtual_small_start_bench, "setting range from virtual first index", "v[1:1] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_small_end_bench, "setting range from virtual last index", "v[last:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_front_half_bench, "setting range from virtual first half", "v[1:half] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_end_half_bench, "setting range from virtual last half", "v[half_plus_1:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_entire_bench1, "setting range from virtual whole with number", "v[1:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_virtual_entire_bench2, "setting range from virtual whole with colon", "v[:] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_small_start_bench, "setting range from normal first index", "n[1:1] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_small_end_bench, "setting range from normal last index", "n[last:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_front_half_bench, "setting range from normal first half", "n[1:half] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_end_half_bench, "setting range from normal last half", "n[half_plus_1:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_entire_bench1, "setting range from normal whole with number", "n[1:last] = 1", num_test))
    println(benchmark_file, benchmark(set_index_normal_entire_bench2, "setting range from normal whole with colon", "n[:] = 1", num_test))
    println(benchmark_file, compare(
        [
            set_index_virtual_small_start_bench, set_index_virtual_small_end_bench,
            set_index_virtual_front_half_bench, set_index_virtual_end_half_bench,
            set_index_virtual_entire_bench1, set_index_virtual_entire_bench2,
            set_index_normal_small_start_bench, set_index_normal_small_end_bench,
            set_index_normal_front_half_bench, set_index_normal_end_half_bench,
            set_index_normal_entire_bench1, set_index_normal_entire_bench2
        ], num_test))

    print_seperator(benchmark_file, "addition")

    addition_virtual_bench() = v + 1
    addition_normal_bench() = n + 1

    println(benchmark_file, benchmark(addition_virtual_bench, "addition virtual array", "v + 1", num_test))
    println(benchmark_file, benchmark(addition_normal_bench, "addition normal array", "n + 1", num_test))
    println(benchmark_file, compare([addition_virtual_bench, addition_normal_bench], num_test))

    print_seperator(benchmark_file, "subtraction")

    subtraction_virtual_bench() = v - 1
    subtraction_normal_bench() = n - 1

    println(benchmark_file, benchmark(subtraction_virtual_bench, "subtraction virtual array", "v - 1", num_test))
    println(benchmark_file, benchmark(subtraction_normal_bench, "subtraction normal array", "n - 1", num_test))
    println(benchmark_file, compare([subtraction_virtual_bench, subtraction_normal_bench], num_test))

    print_seperator(benchmark_file, "multiplication")

    multiplication_virtual_bench() = v * 2
    multiplication_normal_bench() = n * 2

    println(benchmark_file, benchmark(multiplication_virtual_bench, "multiplication virtual array", "v * 1", num_test))
    println(benchmark_file, benchmark(multiplication_normal_bench, "multiplication normal array", "n * 1", num_test))
    println(benchmark_file, compare([multiplication_virtual_bench, multiplication_normal_bench], num_test))

    print_seperator(benchmark_file, "division")

    division_virtual_bench() = v / 2
    division_normal_bench() = n / 2

    println(benchmark_file, benchmark(division_virtual_bench, "division virtual array", "v / 1", num_test))
    println(benchmark_file, benchmark(division_normal_bench, "division normal array", "n / 1", num_test))
    println(benchmark_file, compare([division_virtual_bench, division_normal_bench], num_test))

    print_seperator(benchmark_file, "size")

    size_virtual_bench() = size(v)
    size_normal_bench() = size(n)

    println(benchmark_file, benchmark(size_virtual_bench, "size of a virtual array", "size(v)", num_test))
    println(benchmark_file, benchmark(size_normal_bench, "size of a normal array", "size(n)", num_test))
    println(benchmark_file, compare([size_virtual_bench, size_normal_bench], num_test))

    print_seperator(benchmark_file, "length")

    length_virtual_bench() = length(v)
    length_normal_bench() = length(n)

    println(benchmark_file, benchmark(length_virtual_bench, "length of a virtual array", "length(v)", num_test))
    println(benchmark_file, benchmark(length_normal_bench, "length of a normal array", "length(n)", num_test))
    println(benchmark_file, compare([length_virtual_bench, length_normal_bench], num_test))

    print_seperator(benchmark_file, "eachindex")

    eachindex_virtual_bench() = eachindex(v)
    eachindex_normal_bench() = eachindex(n)

    println(benchmark_file, benchmark(eachindex_virtual_bench, "eachindex of a virtual array", "eachindex(v)", num_test))
    println(benchmark_file, benchmark(eachindex_normal_bench, "eachindex of a normal array", "eachindex(n)", num_test))
    println(benchmark_file, compare([eachindex_virtual_bench, eachindex_normal_bench], num_test))

    standard() = 0

    print_seperator(benchmark_file, "virtual array")

    println(benchmark_file, compare(
    [
        standard,
        virtual_cat_bench, virtual_vcat_bench, virtual_hcat_bench, constructor_1, constructor_2, constructor_3, constructor_4,
        get_index_virtual_bench1, get_index_virtual_bench2, get_index_virtual_bench3,
        get_index_virtual_small_start_bench, get_index_virtual_small_end_bench,
        get_index_virtual_front_half_bench, get_index_virtual_end_half_bench,
        get_index_virtual_entire_bench1, get_index_virtual_entire_bench2,
        set_index_virtual_bench1, set_index_virtual_bench2, set_index_virtual_bench3,
        set_index_virtual_small_start_bench, set_index_virtual_small_end_bench,
        set_index_virtual_front_half_bench, set_index_virtual_end_half_bench,
        set_index_virtual_entire_bench1, set_index_virtual_entire_bench2,
        addition_virtual_bench,
        subtraction_virtual_bench,
        multiplication_virtual_bench,
        division_virtual_bench,
        size_virtual_bench,
        length_virtual_bench,
        eachindex_virtual_bench
    ],
    num_test), "\n")

    print_seperator(benchmark_file, "normal array")

    println(benchmark_file, compare(
    [
        standard,
        cat_bench,
        get_index_normal_bench1, get_index_normal_bench2, get_index_normal_bench3,
        get_index_normal_small_start_bench, get_index_normal_small_end_bench,
        get_index_normal_front_half_bench, get_index_normal_end_half_bench,
        get_index_normal_entire_bench1, get_index_normal_entire_bench2,
        set_index_normal_bench1, set_index_normal_bench2, set_index_normal_bench3,
        set_index_normal_small_start_bench, set_index_normal_small_end_bench,
        set_index_normal_front_half_bench, set_index_normal_end_half_bench,
        set_index_normal_entire_bench1, set_index_normal_entire_bench2,
        addition_normal_bench,
        subtraction_normal_bench,
        multiplication_normal_bench,
        division_normal_bench,
        size_normal_bench,
        length_normal_bench,
        eachindex_normal_bench
    ],
    num_test), "\n")

    print_seperator(benchmark_file, "overall")

    println(benchmark_file, compare(
    [
        standard,
        virtual_cat_bench, virtual_vcat_bench, virtual_hcat_bench, constructor_1, constructor_2, constructor_3, constructor_4, cat_bench,
        get_index_virtual_bench1, get_index_virtual_bench2, get_index_virtual_bench3, get_index_normal_bench1, get_index_normal_bench2, get_index_normal_bench3,
        get_index_virtual_small_start_bench, get_index_virtual_small_end_bench,
        get_index_virtual_front_half_bench, get_index_virtual_end_half_bench,
        get_index_virtual_entire_bench1, get_index_virtual_entire_bench2,
        get_index_normal_small_start_bench, get_index_normal_small_end_bench,
        get_index_normal_front_half_bench, get_index_normal_end_half_bench,
        get_index_normal_entire_bench1, get_index_normal_entire_bench2,
        set_index_virtual_bench1, set_index_virtual_bench2, set_index_virtual_bench3, set_index_normal_bench1, set_index_normal_bench2, set_index_normal_bench3,
        set_index_virtual_small_start_bench, set_index_virtual_small_end_bench,
        set_index_virtual_front_half_bench, set_index_virtual_end_half_bench,
        set_index_virtual_entire_bench1, set_index_virtual_entire_bench2,
        set_index_normal_small_start_bench, set_index_normal_small_end_bench,
        set_index_normal_front_half_bench, set_index_normal_end_half_bench,
        set_index_normal_entire_bench1, set_index_normal_entire_bench2,
        addition_virtual_bench, addition_normal_bench,
        subtraction_virtual_bench, subtraction_normal_bench,
        multiplication_virtual_bench, multiplication_normal_bench,
        division_virtual_bench, division_normal_bench,
        size_virtual_bench, size_normal_bench,
        length_virtual_bench, length_normal_bench,
        eachindex_virtual_bench, eachindex_normal_bench
    ],
    num_test), "\n")
end