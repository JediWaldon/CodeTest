#=
Please see rope10.jl for better code.
It can be adapted to do exactly the same thing as this, but better.
A lot of the code here is for visualization which is ignored in rope10.jl.
=#

#=
visualization  code
=#
function setup()
    return ([ '.' '.' '.'; '.' 'H' '.'; '.' '.' '.' ], [2 2], [2 2])
end

#=
visualization code
=#
function newRow(len::Int, mode::Int)
    if mode == 1
        return fill('.', 1, len)
    else
        return fill('.', len, 1)
    end
end

#=
visualization and code that does something useful.
=#
function step(curr::Matrix{Char}, head, tail, dir::Char, list::Matrix)
    dia = isDiagonal(head, tail)
    vec = [0 0]
    curr[tail[1], tail[2]] = '.'
    curr[head[1], head[2]] = '.'

    # Determine what direction the head is traveling
    if dir == 'U'
        vec = [-1 0]
    elseif dir == 'R'
        vec = [0 1]
    elseif dir == 'D'
        vec = [1 0]
    elseif dir == 'L'
        vec = [0 -1]
    else
        error("Not a direction")
    end

    # Resize the array if necessary
    if (head + vec)[1] == 1 
        row = newRow(size(curr, 2), 1)
        curr = vcat(row, curr)
        head += [1 0]
        tail += [1 0]
        list[:, 1] = map(z->list[z, 1] += 1, 1:size(list, 1))
    elseif (head + vec)[2] == 1
        col = newRow(size(curr, 1), 0)
        curr = hcat(col, curr)
        head += [0 1]
        tail += [0 1]
        list[:, 2] = map(z->list[z, 2] += 1, 1:size(list, 1))
    elseif (head + vec)[1] == size(curr, 1)
        row = newRow(size(curr, 2), 1)
        curr = vcat(curr, row)
    elseif (head + vec)[2] == size(curr, 2)
        col = newRow(size(curr, 1), 0)
        curr = hcat(curr, col)
    end

    # Move all elements accordingly
    if dia && sep(head + vec, tail) == 3
        tail = head
        head += vec
    elseif isDiagonal(head + vec, tail) || sep(head + vec, tail) <= 1
        head += vec
    else
        head += vec
        tail += vec
    end
    if !part(list, tail)
        list = vcat(list, tail)
    end
    curr[tail[1], tail[2]] = 'T'
    curr[head[1], head[2]] = 'H'
    return (curr, head, tail, list)
end

#=
test code for diagonality.
=#
function isDiagonal(head, tail)
    return abs(head[1] - tail[1]) == 1 && abs(head[2] - tail[2]) == 1
end

#=
returns how far apart the head and tail of the rope are.
=#
function sep(head, tail)
    return abs(head[1] - tail[1]) + abs(head[2] - tail[2])
end

#=
See full comment in rope10.jl
=#
function part(list::Matrix{Int}, coord::Matrix{Int})
    for i = 1: size(list, 1)
        if list[i, :] == coord[1,:]
            return true
        end
    end
    return false
end

#=
A less useful version of the one in rope10.jl
=#
function rope()
    A, head, tail = setup()
    list = tail
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day9/input.txt") do io
        while !eof(io)
            line = readline(io)
            char = line[1]
            num = parse(Int, line[3:length(line)])
            for i = 1: num
                A, head, tail, list = step(A, head, tail, char, list)
            end
        end
    end

    # for i = 1: size(list, 1)
    #     A[list[i, 1], list[i, 2]] = '#'
    # end
    # display(A)
    return size(list, 1)
end
