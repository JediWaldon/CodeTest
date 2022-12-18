include("elf.jl")

#=
Elves are traveling on a hike and need to know who is carrying the most 
calories so that they know who to turn to for a snack.
=#
mutable struct ElfList 
    len::Int
    elves::Array{Elf}
end

#=
The constructElfList function constructs an ElfList with one elf in it.
@param snack is the number of calories the first snack the elf is carrying has.
@return the new ElfList.
=#
function constructElfList(snack::Int)
    return ElfList(1, [constructElf(1, snack)])
end

#=
The readIntoElfList function reads the hardcoded file and processes it line by line. Empty lines are interpreted as new elves. 
@returns a tuple of the index of the elf with the most calories, the calories they are carrying and the second and third most calories carried by other elves.
=#
function readIntoElfList()
    # readdlm("../files/example.txt", '\n')
    # rm("../files/example.txt")
    elist = nothing
    maxVal = 0
    maxIdx = 1
    secVal = 0
    thirdVal = 0
    i = 1
    newElf = true
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day1/input.txt") do io
        while !eof(io)
            word = readline(io)
            if length(word) == 0
                i += 1
                newElf = true
            else
                res = parse(Int64, word)
                if newElf && i != 1
                    addElf(elist, res)
                elseif !newElf
                    addCalories(elist.elves[i], res)
                elseif newElf && i == 1
                    elist = constructElfList(res)
                end
                newElf = false
            end
            if !newElf
                val = elist.elves[i].total
                if val > maxVal
                    thirdVal = secVal
                    secVal = maxVal
                    maxVal = val
                    maxIdx = i
                elseif val > secVal 
                    thirdVal = secVal
                    secVal = val
                elseif val > thirdVal
                    thirdVal = val
                end
            end
        end
    end
    return (maxIdx, maxVal, secVal, thirdVal)
end

#=
addElf adds a new elf to the ElfList
@param elist is the ElfList being modified
@param snack is the number of calories of the first snack the elf is carrying.
=#
function addElf(elist::ElfList, snack::Int)
    e = constructElf(elist.len + 1, snack)
    elist.len += 1
    elist.elves = hcat(elist.elves, [e])
end