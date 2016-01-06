module VirtualArrays

export VirtualArray, getindex, setindex!, eltype, size, length

immutable VirtualArray{T,N,P<:AbstractArray} <: AbstractArray{T,N}
    parent_1::P
    parent_2::P
end

import Base.size
import Base.getindex
import Base.length
import Base.setindex!

eltype{T,N,P}(::Type{VirtualArray{T,N,P}}) = T
size(V::VirtualArray) = length(V.parent_1) + length(V.parent_2)
length(V::VirtualArray) = length(V.parent_1) + length(V.parent_2)

function getindex{T,N,P}(V::VirtualArray{T,N,P}, I::Int...)
    #return [V.parent_1[I[1]:end], V.parent_2[1:I[end]-length(V.parent_1)]]
    if I[1] > length(V.parent_1)
        return V.parent_2[I[1]-length(V.parent_1)]
    else
        return V.parent_1[I[1]]
    end
end

function setindex!{T,N,P}(V::VirtualArray{T,N,P}, v, I::Int...)
    if I[1] > length(V.parent_1)
        V.parent_2[I[1]-length(V.parent_1)] = v
    else
        V.parent_1[I[1]] = v
    end
end

end # module
