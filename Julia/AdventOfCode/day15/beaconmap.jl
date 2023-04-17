#=
beacons solves day 15 of Advent of Code 2022. 

Part 1 looks for the number of spots seen on a specific 
row by all the sensors that don't contain a beacon.

Part 2 looks for the single space in the xy grid (0-20 
in the example)(0-4000000 in the actual problem) that 
isn't seen by the sensors because that is where the 
distress beacon is.

@return the tuning frequency of the distress beacon.
=#
function beacons()
    sensors = []
    beacons = []
    dists = []

    open(pwd() * "/Julia/AdventOfCode/day15/input.txt") do io
        while !eof(io)
            line = readline(io)
            tokens = split(line, (' ', ',', '=', ':'))
            sensors = vcat(sensors, 1)

            senco = [parse(Int, tokens[4]), parse(Int, tokens[7])]
            sensors[end] = senco

            # xmin, xmax, ymin, ymax = minmax(xmin, xmax, ymin, ymax, senco)

            beaco = [parse(Int, tokens[14]), parse(Int, tokens[17])]
            if !(beaco in beacons)
                beacons = vcat(beacons, 1)
                beacons[end] = beaco
                # xmin, xmax, ymin, ymax = minmax(xmin, xmax, ymin, ymax, beaco)
            end

            dists = vcat(dists, manhattan(senco, beaco))
        end
    end

    # y = 10 # Example
    y = 2000000 # Input
    r = rowRange(sensors, dists, y)

    # Part 1
    sum = 0
    for el in r
        sum += el[2] - el[1] + 1
        for b in beacons
            if b[2] == y && b[1] >= el[1] && b[1] <= el[2]
                sum -= 1
            end
        end
    end
    println("Part 1: $sum")

    # Part 2
    mult = 4000000

    ans = 0
    # y_bound = 20 # Example
    y_bound = 4000000 # Input
    for i = 1:y_bound+1
        r = rowRange(sensors, dists, i - 1)
        if size(r, 1) == 2
            # display(r)
            # display((r[1][2], i - 1))
            ans = (r[1][2] + 1) * mult + i - 1
            break
        end
    end
    println("Part 2: $ans")

    # display((xmin - xmax, ymin - ymax))
end

#=
manhattan finds the manhattan distance between the sensor and the beacon.
@param senco is the coordinate pair of the sensor.
@param beaco is the coordinate pair of the beacon.
@return the manhattan distance between the two points.
=#
function manhattan(senco, beaco)
    return abs(senco[1] - beaco[1]) + abs(senco[2] - beaco[2])
end

#=
sensorRange finds the range on a given row that a sensor can detect. If it cannot see anything on the given row nothing will be returned.
@param sensor is the sensor being checked.
@param dist is how far the sensor can detect out from itself.
@param row is the row being evaluated.
@return nothing or a matrix containing the start and end values on the row that the sensor can detect.
=#
function sensorRange(sensor, dist, row)
    steps = dist - abs(sensor[2] - row)
    if steps < 0
        return
    end
    return [(sensor[1] - steps), (sensor[1] + steps)]
end

#=
rowRange finds the ranges of all the sensors on a given row. If the row is out of range of all the sensors, nothing is returned. Otherwise the group of consolidated ranges covered by the sensors is returned.

@param sensors is the vector of all sensors.
@param is the vector of manhattan distances from each sensor to a beacon.
@param row is the row being evaluated.

@return the range(s) that are covered by the sensors or nothing if no sensors can perceive the row.
=#
function rowRange(sensors, dists, row)
    ranges::Vector{Vector{Int}} = []
    i = 1
    for sensor in sensors
        res = sensorRange(sensor, dists[i], row)
        i += 1
        if !isnothing(res)
            if size(range, 1) != 0
                ranges = combineRanges(ranges, res)
            else
                ranges = [res]
            end
        end
    end
    return ranges
end

#=
combineRanges combines the set of ranges with the new range given to it. It then returns the new set of ranges to the caller. It will consolidate all ranges so that areas are not double counted.

@param ranges is a vector of vectors containing the bounds of the ranges.
@param res is a vector with the bounds of a new range.

@return a new set of ranges with as few vectors as possible.
=#
function combineRanges(ranges::Vector{Vector{Int}}, res::Vector{Int})
    inserted = false
    contains = false
    # display(ranges)

    # find where the new range falls.
    for ran in ranges

        # It overlaps with the end of the previously recorded range.
        if res[1] >= ran[1] && res[1] <= ran[2] + 1 && res[2] > ran[2]
            ran[2] = res[2]
            # println("A")
            inserted = true
            contains = true

            # It overlaps with the start of the previouslty recorded range.
        elseif res[1] < ran[1] && res[2] >= ran[1] - 1 && res[2] <= ran[2]
            ran[1] = res[1]
            # println("B")
            inserted = true
            contains = true

            # It engulfs the previously recorded range.
        elseif res[1] <= ran[1] - 1 && res[2] >= ran[2] + 1
            ran[:] = res[:]
            # println("C")
            inserted = true
            contains = true

            # It is engulfed by a previously recorded range.
        elseif res[1] >= ran[1] && res[2] <= ran[2]
            # println("D")
            contains = true
        end
    end

    newRanges = []

    # Sort ranges and add new ones if necessary and if they are neighbors combine the ranges.
    if size(ranges, 1) > 1 && inserted
        ranges = sort(ranges)

        # display(ranges)
        newRanges = [ranges[1]]
        for i = 1:size(ranges, 1)-1
            if ranges[i][2] >= ranges[i+1][1]
                # println("Hey")
                newRanges[end][2] = ranges[i+1][2]
            elseif !containsVec(newRanges, ranges[i+1])
                # println("Sup")
                newRanges = vcat(newRanges, [1])
                newRanges[end] = ranges[i+1]
            end
            # display(newRanges)
        end
    elseif !contains
        # println("Well")
        newRanges = ranges
        newRanges = vcat(ranges, 1)
        newRanges[end] = res
    else
        newRanges = ranges
    end
    newRanges = sort(newRanges)

    return newRanges
end

#=
containsVec checks if the first vector contains the given vector. If the vector is found it rturns true, otherwise it returns false.

@param vecVec is the vector that might contain the other vector.
@param vec is the vector being looked for in the other vector.

@return true if the vector is found, otherwise false.
=#
function containsVec(vecVec::Vector{Any}, vec::Vector)
    for vect in vecVec
        if vect == vec
            return true
        end
    end
    return false
end
