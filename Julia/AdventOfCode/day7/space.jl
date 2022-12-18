include("sysTree.jl")

#=
readCL reads a file modeling the input and output from a terminal.
It computes the sizes of directories and determines what should be deleted in order to install an update.
@return the size of the directory to be deleted.
=#
function readCL()
    tree = constructSysTree()
    dir = tree.root
    dirList = []
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day7/input.txt") do io
        while !eof(io)
            dir = command(io, tree, dir)
            if !(dir in dirList)
                dirList = vcat(dirList, dir)
            end
        end
    end

    #=
    This was for the first part of day 7.
    Find the sum of all directories' sizes whose size is smaller than 100000.
    =#
    sum = 0
    for i = 1:length(dirList)
        if dirList[i].size < 100000
            sum += dirList[i].size
        end
    end

    #=
    This was for the second half of day 7.
    There is 70000000 units of space on the device.
    Need to free up at least 30000000 space for the update.
    Find the smallest directory to delete in order to get enough space for the update.
    =#
    tSpace = 70000000
    threshold = 30000000
    uSpace = tSpace - tree.root.size
    smallest = tSpace
    for i = 1:length(dirList)
        curr = dirList[i].size
        if curr < smallest && curr + uSpace > threshold
            smallest = curr
        end
    end
    return smallest
end

#=
command takes the io stream and tree structure and the current directory and executes either the cd or ls command depending on the next line of the file being read. It returns the current directory.
@param io is the io stream.
@param tree is the directory tree.
@param dir is the current working directory.
@return the current working directory.
=#
function command(io, tree::SysTree, dir::SysDir)
    line = readline(io)
    if String(line[1:4]) == "\$ cd"
        dir = doCD(tree, dir, line[6:length(line)])
    elseif String(line[1:4]) == "\$ ls"
        doLS(io, dir)
    end
    return dir
end

#=
doCD changes the directory that dir is pointing to to the one specified by the file.
@param tree is the tree of the system.
@param dir is the current working directory
@param str is the name of the directory being moved into.
@return the current working directory
=#
function doCD(tree::SysTree, dir::SysDir, str::String)
    if str == "/"
        return tree.root
    elseif str == ".."
        return dir.parent
    else
        for i = 1: length(dir.children)
            if dir.children[i].name == str
                return dir.children[i]
            end
        end
    end
end

#=
doLS reads the file and records the contents of the current working directory into the tree.
@param io is the io stream
@param dir is the current working directory.
=#
function doLS(io, dir::SysDir)
    while !eof(io) && peek(io, Char) != '$'
        line = readline(io)
        part1, part2 = split(line, ' ')
        if part1 == "dir"
            addChild(dir, String(part2))
        else 
            addChild(dir, String(part2), parse(Int, part1))
        end
    end
end