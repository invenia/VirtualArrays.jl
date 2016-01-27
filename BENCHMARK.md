## Benchmarking VirtualArray

Checking the performance of VirtualArray

### To run these BenchMarks

You need `Benchmark.jl`, which you can get [here](https://github.com/johnmyleswhite/Benchmark.jl).

### Test Ran

The code I used to benchmark,

```julia
num_parents = 1000
len = 1000

parents = []
for i in 1:num_parents
    push!(parents, rand(Int64, len))
end

virtual_cat_bench() = virtual_cat(1, parents...)
virtual_vcat_bench() = virtual_vcat(parents...)
virtual_hcat_bench() = virtual_hcat(parents...)
constructor_1() = VirtualArray{Int64, 1}(parents...)
constructor_2() = VirtualArray{Int64, 1}(1, parents...)
constructor_3() = VirtualArray{Int64, 2}(1, parents...)
constructor_4() = VirtualArray{Int64, 2}(2, parents...)
cat_bench() = cat(1, parents...)

num_test = 100

display(benchmark(virtual_cat_bench, "virtual_cat", "virtual_cat(1, parents...)", num_test))
display(benchmark(virtual_vcat_bench, "virtual_vcat", "virtual_vcat(parents...)", num_test))
display(benchmark(virtual_hcat_bench, "virtual_hcat", "virtual_hcat(parents...)", num_test))
display(benchmark(constructor_1, "constructor_1", "VirtualArray{Int64, 1}(parents...)", num_test))
display(benchmark(constructor_2, "constructor_2", "VirtualArray{Int64, 1}(1, parents...)", num_test))
display(benchmark(constructor_3, "constructor_3", "VirtualArray{Int64, 1}(1, parents...)", num_test))
display(benchmark(constructor_4, "constructor_4", "VirtualArray{Int64, 2}(2, parents...)", num_test))

v = VirtualArray{Int64, 1}(1, parents...)

get_index_bench1() = v[1]
get_index_bench2() = v[1000000]
get_index_bench3() = v[end]

display(benchmark(get_index_bench1, "getting first index", "v[1]", num_test))
display(benchmark(get_index_bench2, "getting last index", "v[1000000]", num_test))
display(benchmark(get_index_bench3, "getting last index with end", "v[end]", num_test))

set_index_bench1() = v[1] = 1
set_index_bench2() = v[1000000] = 1
set_index_bench3() = v[end] = 1

display(benchmark(set_index_bench1, "setting first index", "v[1] = 1", num_test))
display(benchmark(set_index_bench2, "setting last index", "v[1000000] = 1", num_test))
display(benchmark(set_index_bench3, "setting last index with end", "v[end] = 1", num_test))

size_bench() = size(v)

display(benchmark(size_bench, "size of v", "size(v)", num_test))

length_bench() = length(v)

display(benchmark(length_bench, "length of v", "length(v)", num_test))

eachindex_bench() = eachindex(v)

display(benchmark(eachindex_bench, "eachindex of v", "eachindex(v)", num_test))
```

### Results

The results of the test above,

```
1x12 DataFrames.DataFrame
| Row | Category      | Benchmark                    | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             |
|-----|---------------|------------------------------|------------|-----------|-------------|------------|-------------|-----------------------|
| 1   | "virtual_cat" | "virtual_cat(1, parents...)" | 100        | 0.0950809 | 0.000950809 | 0.00769744 | 0.000703036 | "2016-01-26 18:22:17" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category       | Benchmark                  | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             |
|-----|----------------|----------------------------|------------|-----------|-------------|------------|-------------|-----------------------|
| 1   | "virtual_vcat" | "virtual_vcat(parents...)" | 100        | 0.092835  | 0.00092835  | 0.00322401 | 0.000720582 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category       | Benchmark                  | Iterations | TotalWall | AverageWall | MaxWall   | MinWall    | Timestamp             |
|-----|----------------|----------------------------|------------|-----------|-------------|-----------|------------|-----------------------|
| 1   | "virtual_hcat" | "virtual_hcat(parents...)" | 100        | 0.113704  | 0.00113704  | 0.0335061 | 0.00070508 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category        | Benchmark                            | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             |
|-----|-----------------|--------------------------------------|------------|-----------|-------------|------------|-------------|-----------------------|
| 1   | "constructor_1" | "VirtualArray{Int64, 1}(parents...)" | 100        | 0.0851377 | 0.000851377 | 0.00257738 | 0.000655112 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category        | Benchmark                               | Iterations | TotalWall | AverageWall | MaxWall   | MinWall     | Timestamp             |
|-----|-----------------|-----------------------------------------|------------|-----------|-------------|-----------|-------------|-----------------------|
| 1   | "constructor_2" | "VirtualArray{Int64, 1}(1, parents...)" | 100        | 0.101479  | 0.00101479  | 0.0218142 | 0.000649094 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category        | Benchmark                               | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             |
|-----|-----------------|-----------------------------------------|------------|-----------|-------------|------------|-------------|-----------------------|
| 1   | "constructor_3" | "VirtualArray{Int64, 1}(1, parents...)" | 100        | 0.0838254 | 0.000838254 | 0.00440028 | 0.000656713 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category        | Benchmark                               | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             |
|-----|-----------------|-----------------------------------------|------------|-----------|-------------|------------|-------------|-----------------------|
| 1   | "constructor_4" | "VirtualArray{Int64, 2}(2, parents...)" | 100        | 0.0834594 | 0.000834594 | 0.00666117 | 0.000657667 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category              | Benchmark | Iterations | TotalWall | AverageWall | MaxWall    | MinWall     | Timestamp             | JuliaHash                                  |
|-----|-----------------------|-----------|------------|-----------|-------------|------------|-------------|-----------------------|--------------------------------------------|
| 1   | "getting first index" | "v[1]"    | 100        | 0.0237809 | 0.000237809 | 0.00361007 | 0.000127327 | "2016-01-26 18:22:18" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category             | Benchmark    | Iterations | TotalWall | AverageWall | MaxWall   | MinWall     | Timestamp             | JuliaHash                                  |
|-----|----------------------|--------------|------------|-----------|-------------|-----------|-------------|-----------------------|--------------------------------------------|
| 1   | "getting last index" | "v[1000000]" | 100        | 0.0665851 | 0.000665851 | 0.0184352 | 0.000277684 | "2016-01-26 18:22:18" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category                      | Benchmark | Iterations | TotalWall | AverageWall | MaxWall   | MinWall     | Timestamp             |
|-----|-------------------------------|-----------|------------|-----------|-------------|-----------|-------------|-----------------------|
| 1   | "getting last index with end" | "v[end]"  | 100        | 0.0704981 | 0.000704981 | 0.0233145 | 0.000317517 | "2016-01-26 18:22:18" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category              | Benchmark  | Iterations | TotalWall | AverageWall | MaxWall     | MinWall     | Timestamp             | JuliaHash                                  |
|-----|-----------------------|------------|------------|-----------|-------------|-------------|-------------|-----------------------|--------------------------------------------|
| 1   | "setting first index" | "v[1] = 1" | 100        | 0.0160856 | 0.000160856 | 0.000297026 | 0.000139112 | "2016-01-26 18:22:18" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category             | Benchmark        | Iterations | TotalWall | AverageWall | MaxWall   | MinWall     | Timestamp             |
|-----|----------------------|------------------|------------|-----------|-------------|-----------|-------------|-----------------------|
| 1   | "setting last index" | "v[1000000] = 1" | 100        | 0.0737282 | 0.000737282 | 0.0207142 | 0.000280324 | "2016-01-26 18:22:19" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category                      | Benchmark    | Iterations | TotalWall | AverageWall | MaxWall   | MinWall     | Timestamp             |
|-----|-------------------------------|--------------|------------|-----------|-------------|-----------|-------------|-----------------------|
| 1   | "setting last index with end" | "v[end] = 1" | 100        | 0.0703119 | 0.000703119 | 0.0235006 | 0.000327871 | "2016-01-26 18:22:19" |

| Row | JuliaHash                                  | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|--------------------------------------------|----------|----------|
| 1   | "d4749d2ca168413f3db659950a1855530b58686d" | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category    | Benchmark | Iterations | TotalWall | AverageWall | MaxWall  | MinWall   | Timestamp             | JuliaHash                                  |
|-----|-------------|-----------|------------|-----------|-------------|----------|-----------|-----------------------|--------------------------------------------|
| 1   | "size of v" | "size(v)" | 100        | 0.0315748 | 0.000315748 | 0.016214 | 7.7675e-5 | "2016-01-26 18:22:19" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category      | Benchmark   | Iterations | TotalWall  | AverageWall | MaxWall     | MinWall   | Timestamp             | JuliaHash                                  |
|-----|---------------|-------------|------------|------------|-------------|-------------|-----------|-----------------------|--------------------------------------------|
| 1   | "length of v" | "length(v)" | 100        | 0.00985062 | 9.85062e-5  | 0.000538665 | 5.4965e-5 | "2016-01-26 18:22:19" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
1x12 DataFrames.DataFrame
| Row | Category         | Benchmark      | Iterations | TotalWall | AverageWall | MaxWall   | MinWall   | Timestamp             | JuliaHash                                  |
|-----|------------------|----------------|------------|-----------|-------------|-----------|-----------|-----------------------|--------------------------------------------|
| 1   | "eachindex of v" | "eachindex(v)" | 100        | 0.01379   | 0.0001379   | 0.0027382 | 6.6573e-5 | "2016-01-26 18:22:19" | "d4749d2ca168413f3db659950a1855530b58686d" |

| Row | CodeHash                                   | OS       | CPUCores |
|-----|--------------------------------------------|----------|----------|
| 1   | "ddb25dde4051902516221c7cc45304c8cca3a210" | "Darwin" | 4        |
```