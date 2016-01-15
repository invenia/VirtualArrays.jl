# VirtualArrays

A way to concatenate arrays without copying values.

[![Build Status](https://travis-ci.org/invenia/VirtualArrays.jl.svg?branch=develop)](https://travis-ci.org/invenia/VirtualArrays.jl) [![Build status](https://ci.appveyor.com/api/projects/status/9v6n6dh8i76o1p1d/branch/develop?svg=true)](https://ci.appveyor.com/project/samuel-massinon-invenia/virtualarrays-jl/branch/develop)
 [![codecov.io](https://codecov.io/github/invenia/VirtualArrays.jl/coverage.svg?branch=develop)](https://codecov.io/github/invenia/VirtualArrays.jl?branch=develop)

The goal of VirtualArray is to have something that acts exactly like `cat` but without copying the values of all the arrays into a new array. This can help with memory usage and allow you to change a value in a VirtualArray and have the change happen one of the parents and vice versa.

Otherwise, VirtualArray should act like any other array.

## Usage

The preferred way of using VirtualArrays is through `virtual_cat`. Which is suppose to act like `cat`, as shown below.

```julia
julia> a = rand(Int8, 2); b = rand(Int8, 2);

julia> c = cat(1,a,b)
4-element Array{Int8,1}:
  90
 -48
   1
  48

julia> v = virtual_cat(1,a,b)
4-element VirtualArrays.VirtualArray{Int8,1}:
  90
 -48
   1
  48
```

There's also `virtual_vcat` and `virtual_hcat`, which act like `vcat` and `hcat`

```julia
julia> c = vcat(a,b)
4-element Array{Int8,1}:
  90
 -48
   1
  48

julia> v = virtual_vcat(a,b)
4-element VirtualArrays.VirtualArray{Int8,1}:
  90
 -48
   1
  48

julia> c = hcat(a,b)
2x2 Array{Int8,2}:
  90   1
 -48  48

julia> v = virtual_hcat(a,b)
2x2 VirtualArrays.VirtualArray{Int8,2}:
  90   1
 -48  48
```

## Modifying Values

One of the features of VirtualArray is that a value changed in VirtualArray should change a value in the parent, and vice versa. Shown below is changing an array produced from `cat` and `virtual_cat`.

```julia
julia> a = rand(Int8, 2); b = rand(Int8, 2);

julia> a
2-element Array{Int8,1}:
 33
 83

julia> c = cat(1,a,b)
4-element Array{Int8,1}:
  33
  83
  19
 -34

julia> c[1] = 1
1

julia> c
4-element Array{Int8,1}:
   1
  83
  19
 -34

julia> a
2-element Array{Int8,1}:
 33
 83

julia> v = virtual_cat(1,a,b)
4-element VirtualArrays.VirtualArray{Int8,1}:
  33
  83
  19
 -34

julia> v[1] = 1
1

julia> v
4-element VirtualArrays.VirtualArray{Int8,1}:
   1
  83
  19
 -34

julia> a
2-element Array{Int8,1}:
  1
 83
```

## Memory Allocation

Since we are not copying values, memory usage is much better, especially when using VirtualArray for large arrays. Below demonstrates the memory usage of concatenating different size arrays with `cat` and `virtual_cat`. As we see, `virtual_cat` consistently uses the same amount of memory, where as `cat` grows.

```julia
julia> len = 1; a = collect(1:len); b = collect(1:len);

julia> cat(1,a,b); virtual_cat(1,a,b); # make sure to compile the function

julia> @allocated cat(1,a,b)
1392

julia> @allocated virtual_cat(1,a,b)
1120

julia> len = 10; a = collect(1:len); b = collect(1:len);

julia> @allocated cat(1,a,b)
1536

julia> @allocated virtual_cat(1,a,b)
1120

julia> len = 1000; a = collect(1:len); b = collect(1:len);

julia> @allocated cat(1,a,b)
17424

julia> @allocated virtual_cat(1,a,b)
1120

julia> len = 100000; a = collect(1:len); b = collect(1:len);

julia> @allocated cat(1,a,b)
1601408

julia> @allocated virtual_cat(1,a,b)
1120
```
