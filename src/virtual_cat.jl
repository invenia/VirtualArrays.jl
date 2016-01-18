
## Use this functions to make creating VirtualArrays easier.

function virtual_cat{T}(expanded_dim::Int, parents::AbstractArray{T}...)
    dim = max(expanded_dim, largest_dim(parents...))
    return VirtualArray{T, dim}(expanded_dim, parents...)
end

function virtual_cat(expanded_dim::Int)
    return virtual_cat(expanded_dim, [])
end

function virtual_vcat{T}(parents::AbstractArray{T}...)
    return virtual_cat(1, parents...)
end

function virtual_hcat{T}(parents::AbstractArray{T}...)
    return virtual_cat(2, parents...)
end

function largest_dim(parents::AbstractArray...)
    largest = 0
    for parent in parents
        largest = max(largest, length(size(parent)))
    end
    return largest
end
