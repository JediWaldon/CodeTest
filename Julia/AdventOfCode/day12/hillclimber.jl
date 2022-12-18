# Turn it into a graph then A*?

using DataStructures

#=
climb reads the file and records the data into a matrix to use as a map.
=#
function climb()
    map = []
    start = [0 0]
    goal = [0 0]
    i = 1
    display(pwd())
    open(pwd() * "/Julia/AdventOfCode/day12/example.txt") do io
        while !eof(io)
            line = readline(io)
            mat = Matrix{Char}(undef, 1, sizeof(line))
            for j = 1:sizeof(line)
                mat[j] = line[j]
                if line[j] == 'S'
                    start = [i j]
                elseif line[j] == 'E'
                    goal = [i j]
                end
            end
            if map != []
                map = vcat(map, mat)
            else
                map = Matrix{Char}(undef, 1, length(mat))
                map[:] = mat[:]
            end
            i += 1
        end
    end
    pq = PriorityQueue()
    enqueue!(pq, [1 2], manhattan([1 2], goal))
    enqueue!(pq, [2 1], manhattan([2 1], goal))
    return pq
end

#=
manhattan finds the manhattan distance between two points.
@param pos is the current position.
@param goal is the goal position of the climb.
@return the manhattan distance between the two points.
=#
function manhattan(pos, goal)
    return abs(goal[1] - pos[1]) + abs(goal[2] - pos[2])
end


