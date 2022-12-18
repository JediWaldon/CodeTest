#=
part confirms that a vector's data is a part of the list Matrix
@param list is the list of places the tail has been.
@param coord is the coordinate of the tail.
@return true if the coordinate has been seen already. Otherwise returns false.
=#
function part(list::Matrix{Int}, coord)
    for i = 1: size(list, 1)
        if list[i, 1] == coord[1] && list[i, 2] == coord[2]
            return true
        end
    end
    return false
end

#=
rope uses simplified physics to model a rope's movement. The head of the rope moves
according to instructions in the given file and the body of the rope follows. The 
number of places the tail of the rope has been is returned at the end.
@return the number of places the tail of the rope has been.
=#
function rope()
    rope = Int.(ones(10, 2))
    list = [ 1 1 ]
    sum = 0
    open(pwd() * "/Julia/AdventOfCode/day9/input.txt") do io
        while !eof(io)
            line = readline(io)
            char = line[1]
            num = parse(Int, line[3:length(line)])

            for i = 1: num
                list = move(rope, char, list)
                sum += 1
            end
        end
    end

    return size(list, 1)
end


#=
move moves the rope according to the vastly simplified physics assumptions.
@param rope is the matrix of the positions of the pieces of the rope.
@param char is the character specifying what direction the rope head is moving.
@param list is the list of places the end of the rope has been.
@return the list of places the end of the rope has been.
=#
function move(rope::Matrix{Int}, char::Char, list::Matrix{Int})
    vec = [0, 0]
    if char == 'U'
        vec = [1, 0]
    elseif char == 'R'
        vec = [0, 1]
    elseif char == 'D'
        vec = [-1, 0]
    elseif char == 'L'
        vec = [0, -1]
    else
        error("Invalid character")
    end

    for i = 1:size(rope, 1)
        rope[i, :] += vec

        if i < 10 
            xdiff = rope[i, 1] - rope[i + 1, 1]
            ydiff = rope[i, 2] - rope[i + 1, 2]
            if abs(xdiff) <= 1
                vec[1] = 0
            end
            if abs(ydiff) <= 1
                vec[2] = 0
            end
            if abs(xdiff) >= 1 && abs(ydiff) >= 1 && abs(ydiff) != abs(xdiff)
                vec = [xdiff/ abs(xdiff), ydiff / abs(ydiff)]
            end
        end
        if vec == [0,0]
            break
        end
    end
    if !part(list, [rope[10, 1] rope[10, 2]])
        list = vcat(list, [rope[10, 1] rope[10, 2]])
    end
    return list

end


#=
What follows is a bunch of useless code that does nothing. My early attempts at it used these.
=#

# #=
# =#
# function setup()
#     return ([ '.' '.' '.'; '.' 'H' '.'; '.' '.' '.' ], [2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2; 2 2])
# end

# #=
# =#
# function newRow(len::Int, mode::Int)
#     if mode == 1
#         return fill('.', 1, len)
#     else
#         return fill('.', len, 1)
#     end
# end

# #=
# =#
# function step(curr::Matrix{Char}, head, tail, dir::Char)
#     dia = isDiagonal(head, tail)
#     vec = [0, 0]
#     curr[tail[1], tail[2]] = '.'
#     curr[head[1], head[2]] = '.'
#     start = tail

#     # Determine what direction the head is traveling
#     if dir == 'U'
#         vec = [-1, 0]
#     elseif dir == 'R'
#         vec = [0, 1]
#     elseif dir == 'D'
#         vec = [1, 0]
#     elseif dir == 'L'
#         vec = [0, -1]
#     else
#         error("Not a direction")
#     end

#     # Resize the array if necessary
#     if (head + vec)[1] == 1 
#         row = newRow(size(curr, 2), 1)
#         curr = vcat(row, curr)
#         head += [1, 0]
#         tail += [1, 0]
#     elseif (head + vec)[2] == 1
#         col = newRow(size(curr, 1), 0)
#         curr = hcat(col, curr)
#         head += [0, 1]
#         tail += [0, 1]
#     elseif (head + vec)[1] == size(curr, 1)
#         row = newRow(size(curr, 2), 1)
#         curr = vcat(curr, row)
#     elseif (head + vec)[2] == size(curr, 2)
#         col = newRow(size(curr, 1), 0)
#         curr = hcat(curr, col)
#     end

#     # Move all elements accordingly
#     if dia && sep(head + vec, tail) >= 3
#         tail = head
#         head += vec
#     elseif isDiagonal(head + vec, tail) || sep(head + vec, tail) <= 1
#         head += vec
#     else
#         head += vec
#         tail += vec
#     end
#     next = tail - start
#     return (curr, head, tail, next)
# end

# #=
# =#
# function isDiagonal(head, tail)
#     return abs(head[1] - tail[1]) != 0 && abs(head[2] - tail[2]) != 0
# end

# #=
# =#
# function sep(head, tail)
#     return abs(head[1] - tail[1]) + abs(head[2] - tail[2])
# end