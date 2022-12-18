#=
tune looks for the signature of the other elves devices and then returns when it had found the start of a message sequence.
@return the index at which it has found the start sequence of a message.
=#
function tune()
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day6/input.txt") do io
        while !eof(io)
            vec = []
            line = readline(io)
            if length(line) == 0
                continue
            end
            for i = 1:length(line)
                char = line[i]
                if length(vec) == 4
                    vec = vcat(vec[2:4], char)
                else
                    vec = vcat(vec, char)
                end
                if length(vec) == 4 && check(vec)
                    return search(line)
                end
            end
        end
    end
end

#=
check verifies that a sequence of characters is in fact a set of unique characters.
@return false if the characters are not unique and true if they are.
=#
function check(vec)
    if length(vec) <= 1
        return false
    end
    for i = 1:length(vec)
        for j = i + 1:length(vec)
            if vec[i] == vec[j]
                return false
            end
        end
    end
    return true
end

#=
search looks for the start of the message sequence which is a sequence of 14 unique characters in th input string.
@param line is the line of text being read.
@return the index at which the end of sequence was discovered.
=#
function search(line)
    vec = []
    for j = 1:length(line)
        char = line[j]
        if length(vec) == 14
            vec = vcat(vec[2:14], char)
        else
            vec = vcat(vec, char)
        end
        if length(vec) == 14 && check(vec)
            return j
        end
    end
end

