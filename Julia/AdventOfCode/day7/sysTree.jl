mutable struct SysNode
    name::String
    size::Int
end

mutable struct SysDir
    parent
    name::String 
    children::Vector{Any}
    size::Int
end

mutable struct SysTree
    root::SysDir
end

#=
=#
function constructSysTree()
    return SysTree(SysDir(nothing, "/", [], 0))
end

#=
=#
function addChild(dir::SysDir, name::String, size::Int=0)
    if size != 0
        dir.children = vcat(dir.children, SysNode(name, size))
        dir.size += size
        parent = dir.parent
        while !isnothing(parent)
            parent.size += size
            parent = parent.parent
        end
    else
        dir.children = vcat(dir.children, SysDir(dir, name, [], 0))
    end
end