__precompile__(true)
module VirtualArrays

export VirtualArray, getindex, setindex!, size, length, eachindex
export virtual_cat, virtual_vcat, virtual_hcat

import Base.size, Base.getindex, Base.length, Base.setindex!, Base.eachindex

include("virtual_cat.jl")

type VirtualArray{T, N} <: AbstractArray{T, N}
    expanded_dim::Int # This is the dimension we expand along
    parents::Array{AbstractArray{T},1}

    function VirtualArray{T, N}(expanded_dim::Int, parents::AbstractArray{T,N}...)
        check_parents_dimensions(expanded_dim, parents...)
        return new(expanded_dim, AbstractArray[parent for parent in parents])
    end
    function VirtualArray{T, N}(parents::AbstractArray{T,N}...)
        check_parents_dimensions(1, parents...)
        return new(1, AbstractArray[parent for parent in parents])
    end
end

eachindex(v::VirtualArray) = 1:length(v)

function size(v::VirtualArray)
    result = [0]
    if !isempty(v.parents)
        result = collect(size(v.parents[1]))
        if length(result) >= v.expanded_dim
            expanded_size = 0
            for parent in v.parents
                expanded_size += size(parent)[v.expanded_dim]
            end
            result[v.expanded_dim] = expanded_size
        else
            expanded_size = length(v.parents)
            push!(result, ones(Int, v.expanded_dim - length(result))  ...)
            result[v.expanded_dim] = expanded_size
        end
    end
    return tuple(result...)
end

function length(v::VirtualArray)
    total = 0
    for parent in v.parents
        total += length(parent)
    end
    return total
end

getindex(v::VirtualArray) = getindex(v::VirtualArray, 1)

function getindex(v::VirtualArray, i::Int...)
    checkbounds(v, i...)
    i = expand_index(v, i...)

    for parent in v.parents
        if i[v.expanded_dim] <= get_dimension_size(parent, v.expanded_dim)
            return parent[i...]
        end
        i[v.expanded_dim] -= get_dimension_size(parent, v.expanded_dim)
    end
end

function getindex{T, N}(v::VirtualArray{T, N}, i::UnitRange...)
    checkbounds(v, i...)
    i = collect(i)
    i_dim = length(i)

    if N == i_dim || v.expanded_dim < i_dim
        getindex_range(v, i...)
    else
        num_runs = 1
        for j in v.expanded_dim+1:N
            num_runs *= size(v)[j]
        end

        getindex_range(v, i..., num_runs=num_runs)
    end
end

function setindex!(v::VirtualArray, n, i::Int...)
    checkbounds(v, i...)
    i = expand_index(v, i...)

    for parent in v.parents
        if i[v.expanded_dim] <= get_dimension_size(parent, v.expanded_dim)
            return parent[i...] = n
        end
        i[v.expanded_dim] -= get_dimension_size(parent, v.expanded_dim)
    end
end

function expand_index(v::VirtualArray, i::Int...)
    result = collect(i)
    len_needed = length(size(v))
    len_have = length(i)

    for at in len_have:len_needed - 1
        last_value = result[end]
        result[end] = fix_zero_index(last_value, size(v)[at])
        push!(result, divide(last_value, size(v)[at]))
    end

    return result
end

function fix_zero_index(value::Int, s::Int)
    value = value % s
    if value == 0
        return s
    else
        return value
    end
end

function divide(value::Int, s::Int)
    if value % s == 0
        return div(value, s)
    else
        return div(value, s) + 1
    end
end

function get_dimension_size(v::AbstractArray, i::Int)
    if length(size(v)) >= i
        return size(v)[i]
    else
        return 1
    end
end

function check_parents_dimensions(ignore_dim::Int, parents::AbstractArray...)
    if !isempty(parents)
        default_parent = parents[1]
        default_size = size(parents[1])
        for parent in parents
            curr_size = size(parent)
            for i in max(length(default_size), length(curr_size))
                if i != ignore_dim && get_dimension_size(parent, i) != get_dimension_size(default_parent, i)
                    throw(DimensionMismatch("mismatch in dimension $i"))
                end
            end
        end
    end
end

function getindex_range(v::AbstractArray, i::UnitRange...; num_runs::Int=1)
    result = []
    i = collect(i)

    # For indexing when we have to go through the parents multiple times.
    # For example, a 3d Virtual Array expanded along the 2nd dimensions and 1d indexing
    for j in 1:num_runs
        for parent in v.parents

            # This tells us which index in i we need to change to get the
            # index the user is asking for
            shifting_index = min(length(i), v.expanded_dim)

            # We alter the shifting_index by this much to abstract the array of arrays
            # We need to calculate it like this in case our indexing is < the expansion dimension
            # We need to calcualte for each parent because parents can have different
            # expanded dimensions length
            shift_by = 1
            for k in shifting_index:v.expanded_dim
                shift_by *= get_dimension_size(parent, k)
            end

            # If we have found an index that should be included in the result
            if i[shifting_index].start <= shift_by

                # We need to index into the parent at the right spot
                start_index = max(1,i[shifting_index].start)
                end_index = min(shift_by,i[shifting_index].stop)
                shifting_range = start_index:end_index

                # If we are going through the parents multiple times, we need to adjust accordingly
                shifting_range += shift_by * (j - 1)

                index = (i[1:shifting_index - 1]..., shifting_range, i[shifting_index + 1:end]...)

                push!(result, parent[index...])
            end

            # If we are done adding indexes to our results
            if i[shifting_index].stop <= shift_by
                return cat(shifting_index, result...)
            end

            # Moving onto the next one
            i[shifting_index] -= shift_by
        end
    end
end

end # module
