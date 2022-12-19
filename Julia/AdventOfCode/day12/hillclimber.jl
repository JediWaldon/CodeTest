# Turn it into a graph then A*?

using DataStructures

#=
climb reads the file and records the data into a matrix to use as a map.
@return the number of steps taken to reach the goal.
=#
function climb()
    map = []
    start = [0 0]
    goal = [0 0]
    i = 1
    open(pwd() * "/Julia/AdventOfCode/day12/input.txt") do io
        while !eof(io)
            line = readline(io)
            mat = Matrix{Char}(undef, 1, sizeof(line))
            for j = 1:sizeof(line)
                mat[j] = line[j]
                if line[j] == 'S'
                    start = [i j]
                    mat[j] = 'a'
                elseif line[j] == 'E'
                    goal = [i j]
                    mat[j] = 'z'
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
    hashmap = Dict{Matrix{Int}, Matrix{Int}}()
    costsofar = Dict{Matrix{Int}, Int}()
    pq = PriorityQueue()
    dir = ['U' 'R' 'D' 'L']
    for d in dir
        hashmap, costsofar, pq = checkPos(map, hashmap, costsofar, pq, start, goal, d)
    end
    # This uses the A* pathfinding algorithm.
    hashmap = starA(map, hashmap, costsofar, pq, goal)
    path = goal
    curr = goal
    while curr != start
        curr = hashmap[curr]
        path = vcat(curr, path)
    end

    # The following prints out the path taken to reach the end goal.
    # This was used for part 2 to visually calculate the answer. 
    # My answer for the first part minus 7.
    # for i = 1:size(map,1)
    #     for j = 1:size(map, 2)
    #         if isInPath(i, j, path)
    #             print('.')
    #         else
    #             print(map[i, j])
    #         end
    #     end
    #     println()
    # end

    return size(path, 1) - 1
end

function isInPath(i, j, path)
    for k = 1: size(path, 1)
        if [i, j] == path[k, :]
            return true
        end
    end
    return false
end

#=
checkPos checks the position in the given direction and the 
elevaation is within a step of the current elevation will 
register the possible move in the hashmap and queue.
@param map is the matrix of characters representing elevation.
@param hashmap is the hashmap of where we came from for each step.
@param pq is the priority queue of next steps.
@param 
=#
function checkPos(map, hashmap, costsofar, pq, curr, goal, dir)
    char = map[curr[1], curr[2]]
    idx = 0
    mag = 0
    cond = 0
    if dir == 'U'
        idx = 1
        mag = - 1
    elseif dir == 'R'
        idx = 2
        mag = 1
        cond = size(map, idx) + 1
    elseif dir == 'D'
        idx = 1
        mag = 1
        cond = size(map, idx) + 1
    elseif dir == 'L'
        idx = 2
        mag = -1
    end
    cost = 0
    if containsPos(costsofar, curr)
        cost = costsofar[curr]
    end
    if curr[idx] + mag != cond
        other = copy(curr)
        other[idx] += mag
        if (!containsPos(hashmap, other) || containsPos(costsofar, other) && costsofar[other] > cost) && map[other[1], other[2]] <= char + 1 # && map[other[1], other[2]] >= char - 1
            hashmap[other] = curr
            if containsPos(costsofar, other) && costsofar[other] > cost && haskey(pq, other)
                delete!(pq, other)
            end
            costsofar[other] = cost + 1
            enqueue!(pq, other, manhattan(other, goal) + cost)
        end
    end
    return (hashmap, costsofar, pq)
end

#=
=#
function starA(map, hashmap, costsofar, pq, goal)
    dir = ['U' 'R' 'D' 'L']
    # t = 1
    # char = 'a'
    # num = 0
    while !containsPos(hashmap, goal)
        # t += 1
        curr = dequeue!(pq)
        # if map[curr[1], curr[2]] > char 
        #     char = map[curr[1], curr[2]]
        #     num = 0 
        # elseif map[curr[1], curr[2]] == char
        #     num += 1
        # end
        # display(t)
        # if t == 4114
        #     for i = 1:size(map,1)
        #         for j = 1:size(map,2)
        #             if containsPos(hashmap, [i j])
        #                 print(' ')
        #             else
        #                 print(map[i,j])
        #             end
        #         end
        #         println()
        #     end
        # end
        for d in dir
            hashmap, costsofar, pq = checkPos(map, hashmap, costsofar, pq, curr, goal, d)
        end
    end
    return hashmap
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

#=
containsPos attempts to access the coordinate in the hashmap. If an error occurs, 
it is because the coordinate is not in the hashmap. The error is caught and false 
is returned. If the access works the function returns true. 
Runtime: O(1)
@param hashmap is the hashmap of all the positions seen so far and where they came from.
@param coord is the coordinate being tested.
@return true if the coordinate is in the hashmap, false otherwise.
=#
function containsPos(hashmap, coord)
    try 
        hashmap[coord]
        return true
    catch
        return false
    end
end
