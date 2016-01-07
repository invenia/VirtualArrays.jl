module VirtualArrays

export VirtualArray, getindex, setindex!, size, length

import Base.size, Base.getindex, Base.length, Base.setindex!

type VirtualArray{T,N} <: AbstractArray{Array{T,N},1}
    parents::Array{Array{T,N},1}

    function VirtualArray(parents::AbstractArray{T,N}...)
        return new(Array[parent for parent in parents])
    end
end


function size(V::VirtualArray)
    total = 0
    for parent in V.parents
        total += length(parent)
    end
    return (total,)
end

function length(V::VirtualArray)
    total = 0
    for parent in V.parents
        total += length(parent)
    end
    return total
end

function getindex{T,N}(V::VirtualArray{T,N}, I::Int...)
    index = I[1]
    for parent in V.parents
        if index <= length(parent)
            return parent[index]
        end
        index -= length(parent)
    end
    throw(BoundsError(V, I))
end

function setindex!{T,N}(V::VirtualArray{T,N}, v, I::Int...)
    index = I[1]
    for parent in V.parents
        if index <= length(parent)
            parent[index] = v
            return
        end
        index -= length(parent)
    end
    throw(BoundsError(V, I))
end

end # module
