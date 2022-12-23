#=

=#
function sandfall()
    xstart, xend, yend = (0, 0, 0)
    map = []
    coords = []
    open(pwd() * "/Julia/AdventOfCode/day14/input.txt") do io
        while !eof(io)
            line = readline(io)
            coords, xstart, xend, yend = genCoords(coords, line, xstart, xend, yend)
        end
    end
    map = genMap(xstart, xend, yend, coords)
    dropPos = 500 - xstart + 2
    map[dropPos, 1] = '+'
    grains = 0
    atRest = true
    while atRest
        map, atRest = dropSand(map, dropPos)
        grains += 1
    end
    grains -= 1
    printMap(map)
    return grains
end

#=
genMap constructs a map of characters from the coordinates
    given in the coords vector. It determines the size of 
    the map using the difference between xstart and xend, 
    and the value of yend. For the vectors within each 
    element of coordinate it fills the lines between each 
    consequetive coordinate pair with '#'.  When the 
    cordinates have all been accounted for it returns the 
    map.
@param xstart is the first index of x with a value.
@param xend is the last index of x with a value.
@param yend is the last index of y with a value.
@param coords is the vector of line vectors containing 
    coordinate pairs.
=#
function genMap(xstart, xend, yend, coords)
    map = fill('.', (xend - xstart + 3, yend + 1))
    for row in coords
        for i = 1:size(row, 1)-1
            start = row[i] - [xstart - 1, 0] + [1, 0]
            stop = row[i+1] - [xstart - 1, 0] + [1, 0]
            begx, enx = start[1] < stop[1] ? (start[1], stop[1]) : (stop[1], start[1])
            begy, eny = start[2] < stop[2] ? (start[2], stop[2]) : (stop[2], start[2])

            len = start[1] - stop[1] != 0 ? start[1] - stop[1] : start[2] - stop[2]

            map[begx:enx, begy:eny] = fill('#', abs(len) + 1)
        end
    end
    return map
end

#=
genCoords finds all the coordinates in a line of the file. It 
    splits the string by the arrow "->" to separate the pairs, 
    stores that in the row. Splits each coordinate pair string 
    using "," and converts character results to integers and 
    stores them in a 2 element vector within row. The x and y 
    elements are compared against xstart, xend, and yend to 
    determine what parts of the map will actually matter. The 
    row is then added to the end of the coordinate vector. At 
    the end, the coorinate vector is returned. 
@param coords is the vector of all the rows and coordinates 
    recorded so far.
@param line is the line of text being analyzed.
@param xstart is the current known lowest x value.
@param xend is the current known highest x value.
@param yend is the current known highest y value.
@return the coordinate vector.
=#
function genCoords(coords, line, xstart, xend, yend)
    vals = split(line, "->")
    row = []
    for val in vals
        vec = parse.(Int, split(val, ","))
        row = vcat(row, 1)
        row[end] = vec
        if row[end][1] > xend
            xend = row[end][1]
            if xstart == 0
                xstart = xend
            end
        elseif row[end][1] < xstart || xstart == 0
            xstart = row[end][1]
        end
        if row[end][2] > yend
            yend = row[end][2]
        end
    end
    coords = vcat(coords, 1)
    coords[end] = row
    return coords, xstart, xend, yend
end

#=
printMap prints out the map's current state. It does so
    by treating it like a transpose in order to properly
    display it.
@param map is the map being printed out.
=#
function printMap(map)
    m, n = size(map)
    for i = 1:n
        for j = 1:m
            print(map[j, i])
        end
        println()
    end
end

#=
dropSand drops a grain of sand (represented as 'o'). 
    The sand moves down if it can, then diagonally 
    left if it can, then diagonally right if it can 
    for each step. If it can make none of those 
    moves it comes to rest.
@param map is the map of the sand.
@param dropPos is where the sand grains are 
    trickling from.
@return the updated map and the boolean atRest.
=#
function dropSand(map, dropPos)
    n = size(map, 2)
    pos = [dropPos, 1]
    down = [0, 1]
    dialeft = [-1, 1]
    diaright = [1, 1]
    atRest = false
    while !atRest && pos[2] < n
        testdown = pos + down
        if map[testdown[1], testdown[2]] == '.'
            pos = testdown
            continue
        end
        testDL = pos + dialeft
        if map[testDL[1], testDL[2]] == '.'
            pos = testDL
            continue
        end
        testDR = pos + diaright
        if map[testDR[1], testDR[2]] == '.'
            pos = testDR
            continue
        end
        atRest = true
    end
    if atRest
        map[pos[1], pos[2]] = 'o'
    end
    return map, atRest
end

