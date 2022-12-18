#=
campPairs returns the number of pairs wher one contains another.
=#
function campPairs()
    sum = 0
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day4/input.txt") do io
        while !eof(io)
            line = readline(io)
            elf1, elf2 = split(line, ',')
            start1, end1 = parse.(Int, split(elf1, '-'))
            start2, end2 = parse.(Int, split(elf2, '-'))
            r1 = range(start1, end1)
            r2 = range(start2, end2)
            if (intersect(r1, r2) == r1 || intersect(r1, r2) == r2)
                sum += 1
            end
        end
    end
    return sum
end

#=
campOverlap returns the number of pairs where they overlap.
=#
function campOverlap()
    sum = 0
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day4/input.txt") do io
        while !eof(io)
            line = readline(io)
            elf1, elf2 = split(line, ',')
            start1, end1 = parse.(Int, split(elf1, '-'))
            start2, end2 = parse.(Int, split(elf2, '-'))
            r1 = range(start1, end1)
            r2 = range(start2, end2)
            if (length(intersect(r1, r2)) != 0)
                sum += 1
            end
        end
    end
    return sum
end