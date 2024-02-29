horline = ['@' '@' '@' '@']
plus = ['.' '@' '.'; '@' '@' '@'; '.' '@' '.']
revl = ['.' '.' '@'; '.' '.' '@'; '@' '@' '@']
verline = ['@' '.'; '@' '.'; '@' '.'; '@' '.']
square = ['@' '@'; '@' '@']

shapes = [horline, plus, revl, verline, square]

function pyroclastics()
    dirs::String = nothing
    open(pwd() * "/Julia/AdventOfCode/day17/input.txt") do io
        while (!eof(io))
            dirs = readline(io) # Should only be the one line
        end
    end
end