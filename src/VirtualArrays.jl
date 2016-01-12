module VirtualArrays

export VirtualArray, getindex, setindex!, size, length, eachindex
export virtual_cat, virtual_vcat, virtual_hcat

import Base.size, Base.getindex, Base.length, Base.setindex!, Base.eachindex

include("virtual_cat.jl")

type VirtualArray{T,N,P<:AbstractArray} <: AbstractArray{T,N}
    expanded_dim::Int # This is the dimension we expand along
    parents::Array{P,1}

    function VirtualArray(expanded_dim::Int, parents::P...)
        check_parents_dimensions(expanded_dim, parents...)
        return new(expanded_dim, Array[parent for parent in parents])
    end
    function VirtualArray(parents::P...)
        check_parents_dimensions(1, parents...)
        return new(1, Array[parent for parent in parents])
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

    divide_by = 1
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

end # module
