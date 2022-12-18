#=
signal reads the file and executes one of two commands.
"noop" which takes a cycle on the machine.
"addx" which adds the specified number to the register.
A sprite is located where the register specifies and has a width of three. 
If a pixel is draw while it is in the same space as the pixel, the pixel is lit.
The pixel array is then printed to the console.
Solution: PBZGRAZA
=#
function signal()
    track = []
    pixels = fill(' ', 6, 40)
    i = 1
    cycle = 1
    reg = 1
    open(pwd() * "/Julia/AdventOfCode/day10/input.txt") do io
        while !eof(io)
            line = readline(io)
            if line[1:4] == "noop"
                # if reg + 1 >= cycle % 40 && reg - 1 <= cycle % 40
                #     pixels[fld(cycle, 40) + 1, (cycle - 1) % 40 + 1] = '#'
                # end
                draw(pixels, reg, cycle)
                cycle += 1
            elseif line[1:4] == "addx"
                num = parse(Int, line[6:length(line)])
                if (cycle + 1 - 20) % 40 == 0
                    track = vcat(track, (cycle + 1) * reg)
                    i += 1
                end
                # if reg + 1 >= cycle % 40 && reg - 1 <= cycle % 40
                #     pixels[fld(cycle, 40) + 1, (cycle - 1) % 40 + 1] = '#'
                # end
                draw(pixels, reg, cycle)
                cycle += 1
                draw(pixels, reg, cycle)
                # if reg + 1 >= cycle % 40 && reg - 1 <= cycle % 40
                #     pixels[fld(cycle, 40) + 1, (cycle - 1) % 40 + 1] = '#'
                # end
                cycle += 1
                reg += num
            else
                error("Invalid input")
            end
            if (cycle - 20) % 40 == 0
                track = vcat(track, cycle * reg)
                i += 1
            end
        end
    end

    # Part 1 of the problem
    # sum = 0
    # for i = 1:size(track, 1)
    #     sum += track[i]
    # end
    # return sum
    for i = 1:size(pixels, 1)
        for j = 1: size(pixels, 2)
            print(pixels[i, j])
        end
        println()
    end
    # return pixels
end

#=
draw checks and fills in the pixel array if the sprite is in the location.
NOTE: The problem assumed a index 0 language, which Julia is not. 
It took some time to realize this and then it worked beautifully.
@param pixels is the array of pixels.
@param reg is the register value.
@param cycle is the cycle the machine is on.
=#
function draw(pixels, reg, cycle)
    if reg + 1 >= cycle % 40 - 1 && reg - 1 <= cycle % 40 - 1
        pixels[fld(cycle, 40) + 1, (cycle - 1) % 40 + 1] = '#'
    end
end