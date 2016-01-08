module VirtualArrays

export VirtualArray, getindex, setindex!, size, length, eachindex

import Base.size, Base.getindex, Base.length, Base.setindex!, Base.eachindex

type VirtualArray{T,N} <: AbstractArray{Array{T,N},1}
    expanded_dim::Int # This is the dimension we expand along
    parents::Array{Array{T,N},1}

    function VirtualArray(expanded_dim::Int, parents::AbstractArray{T,N}...)
        return new(expanded_dim, Array[parent for parent in parents])
    end
    function VirtualArray(parents::AbstractArray{T,N}...)
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
    i = collect(i)
    for parent in v.parents
        if i[v.expanded_dim] <= size(parent)[v.expanded_dim]
            return parent[i...]
        end
        i[v.expanded_dim] -= size(parent)[v.expanded_dim]
    end
    throw(BoundsError(v, i))
end

function setindex!{T,N}(v::VirtualArray{T,N}, n, i::Int...)
    index = i[1]
    for parent in v.parents
        if index <= length(parent)
            parent[index] = n
            return
        end
        index -= length(parent)
    end
    throw(BoundsError(v, i))
end

end # module
