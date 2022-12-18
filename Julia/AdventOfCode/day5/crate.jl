#=
move reads a file of crates and makes a matrix representing them. It then reads the 
instructions to move them from the rest of the file in the format of "move X from Y to Z". It then executes these moves and reports the crates on the top of each of the stacks.
@return the string of crates on the tops of the stacks.
=#
function move()
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day5/input.txt") do io
        crates = makeCrates(io)
        while !eof(io)
            line = readline(io)
            read = true
            j = 0
            nums = Int.(zeros(3))
            if length(line) < 1
                continue
            end
            for i = 1:length(line)
                if line[i] >= '0' && line[i] <= '9'
                    if read
                        nums[j] *= 10
                        nums[j] += parse(Int, line[i])
                    else
                        read = true
                        j += 1
                        nums[j] = parse(Int, line[i])
                    end
                else
                    read = false
                end
            end
            crates = carry(nums[1], nums[2], nums[3], crates)
        end
        return tops(crates)
    end
end

#= 
makeCrates reads the file line by line and creates a row of crates for each. It ignores the last line, which simply labels each column. It returns the matrix of characters to the caller.
@param io is the io stream given by the caller.
@return the matrix of crates.
=#
function makeCrates(io)
    table = true
    crates = []
    while table
        line = readline(io)
        if length(line) == 0
            table = false
            break
        end
        len::Int = (length(line) + 1) / 4
        vector = Int.(zeros(len))
        for i = 1:len
            char = line[i * 4 - 2]
            vector[i] = char
        end
        if crates == []
            crates = vector'
        else
            crates = vcat(crates, vector')
        end
    end
    crates = Char.(crates[1:size(crates, 1) - 1, :])
    return crates
end 

#=
heights calculates the heights of the stacks in the matix. it returns the heights of each stack as a vector.
@return the vector of the heights of each stack.
=#
function heights(crates::Matrix)
    n, m = size(crates)
    vec = zeros(m)
    for i = 1:m
        for j = n:-1:1
            if crates[j, i] != ' '
                vec[i] += 1
            end
        end
    end
    return vec
end

#=
carry moves peices of the matrix around. It carries a number of crates from their starting column to their destination column. If extra rows of height are needed the function will add them. It will encounter an error if anything from an empty column is moved.
@param num is the number of crates being moved.
@param from is the column the crates are being moved from.
@param dest is the destination column of the crates.
@crates is the matrix containing all the information of the position of the crates.
=#
function carry(num::Int, from::Int, dest::Int, crates::Matrix)
    highs = heights(crates)
    length, width = size(crates)
    sub = vect(num)

    height::Int = highs[from]
    startIdx = length - height + 1
    stopIdx = length - height + num

    stack = crates[startIdx:stopIdx, from]
    crates[startIdx:stopIdx, from] = sub

    while highs[dest] + num > length 
        crates = vcat(Char.(Int.(vect(width))'), crates)
        length += 1
    end

    height = highs[dest]
    startIdx = length - height - num + 1
    stopIdx = length - height 
    crates[startIdx:stopIdx, dest] = stack # reverse(stack) for the original problem
    return crates
end

#=
vect creates a vector of spaces of the specified length.
@param length is the number of spaces in the vector.
=#
function vect(len::Int)
    vec = []
    for i = 1:len
        vec = vcat(vec, ' ')
    end
    return vec
end

#=
tops creates a string of the crates on the top of each of the stacks.
@param crates is the matrix representation of the crates in their stacks.
@return the string of all the crates on the tops of their respective stacks.
=#
function tops(crates::Matrix)
    length, width = size(crates)
    highs = Int.(heights(crates))
    str = ""
    for i = 1:width
        topIdx = length - highs[i] + 1
        str *= crates[topIdx, i]
    end
    return str
end
