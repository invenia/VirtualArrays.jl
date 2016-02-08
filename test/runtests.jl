using VirtualArrays
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end
using FactCheck

include("virtual_cat.jl")
include("VirtualArrays.jl")

FactCheck.exitstatus()
