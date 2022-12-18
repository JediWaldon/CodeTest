#=
visible opens the input file and reads the data into a matrix. It then computes the number of trees in the forest that can be seen from the outside. At the end it computes the scenic value of the most scenic tree in the forest.
@return the scenic value of the most scenic tree in the forest.
=#
function visible()
    forest = []
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day8/input.txt") do io
        while !eof(io)
            line = readline(io)
            len = length(line)
            vec = [parse(Int, line[1])]
            for i = 2:len
                num = parse(Int, line[i])
                vec = hcat(vec, num)
            end
            if forest != []
                forest = vcat(forest, vec)
            else
                forest = vec
            end
        end
    end

    #=
    The following was used to determine the number of trees could be seen from outside the forest.
    =#
    m, n = size(forest)
    sum = m * 2 + n * 2 - 4
    for i = 2:m - 1
        for j = 2:n - 1
            if seenUp(forest, i, j) || seenDown(forest, i, j) || seenRight(forest, i, j) || seenLeft(forest, i, j)
                sum += 1
            end
        end
    end
    
    #=
    The following is for the second part of day 8. Determining the ideal tree for scenic views. Each tree is evaluated. Brute force approach.
    =#
    ideal = 0
    for i = 1:m
        for j = 1:n
            val = evalScene(forest, i, j)
            if val > ideal
                ideal = val
            end
        end
    end
    return ideal
end

#=
seenRight computes whether the tree can be seen on the outside from the right.
@param forest is the forest matrix.
@param j is the row of the forest of the tree in question.
@param i is the column of the forest of the tree in question.
@return true if the tree can be seen from the right, false otherwise.
=#
function seenRight(forest, j, i)
    height = forest[j, i]
    for m = i + 1:size(forest, 1)
        if forest[j, m] >= height
            return false
        end
    end
    return true
end

#=
seenLeft computes whether the tree can be seen on the outside from the left.
@param forest is the forest matrix.
@param j is the row of the forest of the tree in question.
@param i is the column of the forest of the tree in question.
@return true if the tree can be seen from the left, false otherwise.
=#
function seenLeft(forest, j, i)
    height = forest[j, i]
    for m = i - 1:-1:1
        if forest[j, m] >= height
            return false
        end
    end
    return true
end

#=
seenUp computes whether the tree can be seen on the outside from the top.
@param forest is the forest matrix.
@param j is the row of the forest of the tree in question.
@param i is the column of the forest of the tree in question.
@return true if the tree can be seen from the top, false otherwise.
=#
function seenUp(forest, j, i)
    height = forest[j, i]
    for m = j - 1:-1:1
        if forest[m, i] >= height
            return false
        end
    end
    return true
end

#=
seenDown computes whether the tree can be seen on the outside from the bottom.
@param forest is the forest matrix.
@param j is the row of the forest of the tree in question.
@param i is the column of the forest of the tree in question.
@return true if the tree can be seen from the bottom, false otherwise.
=#
function seenDown(forest, j, i)
    height = forest[j, i]
    for m = j + 1:size(forest, 1)
        if forest[m, i] >= height
            return false
        end
    end
    return true
end

#=
sceneRight compute how far into the forest to the right the elves can see from the top of the tree in question. 
@param forest is the forest matrix.
@param i is the row of the tree in question inside the forest.
@param j is the column of the tree in question inside the forest.
@return how far into the forest the elves can see from the top of the tree to the right.
=#
function sceneRight(forest, i, j)
    height = forest[i, j]
    sum = 0;
    for m = j + 1:size(forest, 1)
        if forest[i, m] < height
            sum += 1
        else 
            sum += 1
            break
        end
    end
    return sum
end

#=
sceneLeft compute how far into the forest to the left the elves can see from the top of the tree in question. 
@param forest is the forest matrix.
@param i is the row of the tree in question inside the forest.
@param j is the column of the tree in question inside the forest.
@return how far into the forest the elves can see from the top of the tree to the left.
=#
function sceneLeft(forest, i, j)
    height = forest[i, j]
    sum = 0;
    for m = j - 1:-1:1
        if forest[i, m] < height
            sum += 1
        else 
            sum += 1
            break
        end
    end
    return sum
end

#=
sceneUp compute how far into the forest to the top the elves can see from the top of the tree in question. 
@param forest is the forest matrix.
@param i is the row of the tree in question inside the forest.
@param j is the column of the tree in question inside the forest.
@return how far into the forest the elves can see from the top of the tree to the top.
=#
function sceneUp(forest, i, j)
    height = forest[i, j]
    sum = 0;
    for m = i - 1:-1:1
        if forest[m, j] < height
            sum += 1
        else 
            sum += 1
            break
        end
    end
    return sum
end

#=
sceneDown compute how far into the forest to the bottom the elves can see from the top of the tree in question. 
@param forest is the forest matrix.
@param i is the row of the tree in question inside the forest.
@param j is the column of the tree in question inside the forest.
@return how far into the forest the elves can see from the top of the tree to the bottom.
=#
function sceneDown(forest, i, j)
    height = forest[i, j]
    sum = 0;
    for m = i + 1:size(forest, 2)
        if forest[m, j] < height
            sum += 1
        else 
            sum += 1
            break
        end
    end
    return sum
end

#=
evalScene computes the scenic value of the given tree in the forest.
@param forest is the matrix representing the forest.
@param i is the row of the tree inside the forest.
@param j is the column of the tree inside the forest.
@return the scenic value of the given tree.
=#
function evalScene(forest, i, j)
    return sceneDown(forest, i, j) * sceneUp(forest, i, j) * sceneLeft(forest, i, j) * sceneRight(forest, i, j)
end