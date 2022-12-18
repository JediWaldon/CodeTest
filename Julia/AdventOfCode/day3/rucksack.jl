#= 
duplicateItems looks for items that share a type (character) in an elf's rucksack (containging two compartments, modeled by the frist and second halves of a string).
@return the value of rucksacks with items in both compartments that share a type 
=#
function duplicateItems()
    score = 0
    open(pwd() * "/Julia/AdventOfCode/day3/input.txt") do io 
        while !eof(io)
            test = zeros(52)
            line = readline(io)
            len = length(line)
            for i::Int = 1:len/2
                char = line[i]
                if char >= 'A' && char <= 'Z'
                    idx = char - 'A' + 27
                    test[idx] = 1
                    
                elseif char >= 'a' && char <= 'z'
                    idx = char - 'a' + 1
                    test[idx] = 1
                    
                else 
                    error("Invalid character")
                end
            end
            for j::Int = len/2 + 1:len
                char = line[j]
                if char >= 'A' && char <= 'Z'
                    idx = char - 'A' + 27
                    if test[idx] + 1 == 2
                        test[idx] += 1
                        score += idx
                        break
                    end
                elseif char >= 'a' && char <= 'z'
                    idx = char - 'a' + 1
                    if test[idx] + 1 == 2
                        test[idx] += 1
                        score += idx
                        break
                    end   
                else 
                    error("Invalid character")
                end
            end
        end
    end
    return score
end

#=
teamBadge looks throught the contents of each elf's sack and assigns a badge to the team based on what item they share in their rucksacks. The priority of the teams is added up and returned.
@return priority of the teams altogther.
=#
function teamBadge()
    priority = 0
    open("/Users/jeddywaldon/CodeTest/Julia/Advent/day3/input.txt") do io
        while !eof(io)
            elf1 = readline(io)
            elf2 = readline(io)
            elf3 = readline(io)
            len = length(elf1)
            for i = 1:len
                char = elf1[i]
                if contains(elf2, char) && contains(elf3, char)
                    println(char)
                    if char >= 'a' && char <= 'z'
                        priority += char - 'a' + 1
                    else
                        priority += char - 'A' + 27
                    end
                    break
                end
            end
        end
    end
    return priority
end