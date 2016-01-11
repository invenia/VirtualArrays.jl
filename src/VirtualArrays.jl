module VirtualArrays

export VirtualArray, getindex, setindex!, size, length, eachindex

import Base.size, Base.getindex, Base.length, Base.setindex!, Base.eachindex

type VirtualArray{T,N,P<:AbstractArray} <: AbstractArray{T,N}
    expanded_dim::Int # This is the dimension we expand along
    parents::Array{P,1}

    function VirtualArray(expanded_dim::Int, parents::P...)
        return new(expanded_dim, Array[parent for parent in parents])
    end
    function VirtualArray(parents::P...)
        return new(1, Array[parent for parent in parents])
    end
end

eachindex(v::VirtualArray) = 1:length(v)

function size(v::VirtualArray)
    result = [0]
    if !isempty(v.parents)
        expanded_size = 0
        for parent in v.parents
            expanded_size += size(parent)[v.expanded_dim]
        end
        result = collect(size(v.parents[1]))
        result[v.expanded_dim] = expanded_size
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

function getindex{T,N}(v::VirtualArray{T,N}, i::Int...)
    checkbounds(v, i...)
    i = get_correct_index_value(v, i...)

    for parent in v.parents
        if i[v.expanded_dim] <= size(parent)[v.expanded_dim]
            return parent[i...]
        end
        i[v.expanded_dim] -= size(parent)[v.expanded_dim]
    end
end

function setindex!{T,N}(v::VirtualArray{T,N}, n, i::Int...)
    checkbounds(v, i...)
    i = get_correct_index_value(v, i...)

    for parent in v.parents
        if i[v.expanded_dim] <= size(parent)[v.expanded_dim]
            return parent[i...] = n
        end
        i[v.expanded_dim] -= size(parent)[v.expanded_dim]
    end
end

## TODO: Give these three functions much better names
function get_correct_index_value(v::VirtualArray, i::Int...)
    result = collect(i)
    len_needed = length(size(v))
    len_have = length(i)

    divide_by = 1
    for at in len_have:len_needed - 1
        last_value = result[end]
        result[end] = zero_to_end(last_value % size(v)[at], size(v)[at])
        push!(result, divide(last_value, size(v)[at]))
    end

    return result
end

function zero_to_end(value::Int, size::Int)
    if value == 0
        return size
    else
        return value
    end
end

function divide(value::Int, size::Int)
    if value % size == 0
        return div(value, size)
    else
        return div(value, size) + 1
    end
end

end # module
