
## Use this functions to make creating VirtualArrays easier.

function virtual_cat{P}(expanded_dim::Int, parents::P...)
    dim = max(expanded_dim, largest_dim(parents...))

    expr = quote
        VirtualArray{Any, $dim, $P}($expanded_dim, $(parents...))
    end
    return eval(expr)
end

function virtual_cat(expanded_dim::Int)
    return virtual_cat(expanded_dim, [])
end

function virtual_vcat{P}(parents::P...)
    return virtual_cat(1, parents...)
end

function virtual_hcat{P}(parents::P...)
    return virtual_cat(2, parents...)
end

function largest_dim(parents::AbstractArray...)
    largest = 0
    for parent in parents
        largest = max(largest, length(size(parent)))
    end
    return largest
end