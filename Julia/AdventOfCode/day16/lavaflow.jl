using Graphs
using DataStructures
using Random


mutable struct Path
    steps::Vector
    time::Int
    potential::Int
    flowrate::Int
    score::Int
end

mutable struct ElPaths
    uSteps::Vector
    uTime::Int
    elSteps::Vector
    elTime::Int
    potential::Int
    score::Int
end



#=
=#
function lavaflow()
    g = nothing
    table = Dict{Int,String}()
    rev = Dict{String,Int}()
    flows = []
    maxflow = 0

    all_cnxns = []
    open(pwd() * "/Julia/AdventOfCode/day16/input.txt") do io
        g = SimpleGraph{Int}(0)
        i = 1
        while !eof(io)
            line = readline(io)[7:end]
            name = line[1:2]
            table[i] = name
            rev[name] = i
            line = split(line, '=')[2]
            flow = parse(Int, split(line, ';')[1])
            maxflow += flow
            flows = vcat(flows, flow)
            line = split(line, "valve")[2]
            if line[1] == 's'
                line = line[3:end]
            else
                line = line[2:end]
            end
            cnxns = split(line, ", ")
            all_cnxns = vcat(all_cnxns, 1)
            all_cnxns[end] = cnxns
            add_vertex!(g)
            i += 1
        end
    end

    for ver in table
        # print("$(ver[2]) => ")
        for other in all_cnxns[ver[1]]
            # print(other * " ")
            add_edge!(g, ver[1], rev[other])
        end
        # println()
    end

    floywar = floyd_warshall_shortest_paths(g)
    pq = PriorityQueue{Path,Int}(Base.Order.Reverse)
    vec = [] # useful valves
    i = 1
    for el in flows
        if el != 0
            vec = vcat(vec, i)
        end
        i += 1
    end
    start = Path([rev["AA"]], 0, maxflow * 30, 0, 0)
    enqueue!(pq, start, start.score)

    display(part1(pq, floywar, vec, 30, flows))

    elpq = PriorityQueue{ElPaths,Int}(Base.Order.Reverse)
    start = ElPaths([rev["AA"]], 0, [rev["AA"]], 0, maxflow * 26, 0)
    enqueue!(elpq, start, start.potential)
    return part2(elpq, floywar, vec, 26, flows)
end


#=
=#
function part1(pq::PriorityQueue{Path,Int}, floywar, valves, stop, flows)
    curr = peek(pq)[1]
    maxflow = sum(flows)
    bestScore = 0
    bestPath = nothing

    while !isempty(pq) && curr.potential > bestScore && size(curr.steps, 1) - 1 != size(valves, 1)

        choices = findChoices(valves, curr.steps)

        if size(choices, 1) == 0
            if !isempty(pq)
                curr = dequeue!(pq)
                continue
            end
            break
        end

        last = curr.steps[end]
        for step in choices
            next = Path(curr.steps, curr.time, curr.potential, curr.flowrate, curr.score)
            next.steps = vcat(next.steps, step)
            t = floywar.dists[last, step] + 1
            next.time += t
            next.score += t * next.flowrate
            next.flowrate += flows[step]
            if next.time < stop
                potential = maxflow * (stop - next.time) + next.score
                next.potential = potential
                enqueue!(pq, next, next.potential)
                # println("\tValve: [$step] Score: $(next.score)")
                if next.score > bestScore
                    bestScore = next.score
                    bestPath = next
                end
            end
        end

        curr = dequeue!(pq)
    end



    diff = stop - bestPath.time
    println("Best Found Path: $(bestPath.steps)")
    return bestScore + diff * bestPath.flowrate
end

#=
=#
function findChoices(valves, steps)
    choices = []

    for valve in valves
        if !(valve in steps)
            choices = vcat(choices, valve)
        end
    end
    return choices
end

#=
=#
function part2(pq::PriorityQueue{ElPaths,Int}, floywar, valves, stop, flows)
    curr = peek(pq)[1]
    bestScore = 0
    bestPath = nothing
    t = 1

    while !isempty(pq) && curr.potential > bestScore
        choices = findChoices(valves, vcat(curr.uSteps, curr.elSteps))
        if size(choices, 1) == 0
            if !isempty(pq)
                curr = dequeue!(pq)
                continue
            end
            break
        end

        uLast = curr.uSteps[end]
        elLast = curr.elSteps[end]
        for uChoice in choices
            uT = floywar.dists[uLast, uChoice] + 1
            for elChoice in choices

                elT = floywar.dists[elLast, elChoice] + 1
                next = createElPath(curr, uChoice, elChoice, uT, elT, flows, stop, floywar, valves)
                pq, bestScore, bestPath = addToPQ(pq, next, bestScore, bestPath, stop)

            end # for elChoice

        end # for uChoice

        if (t += 1) % 10000 == 0
            println("Score: $bestScore")
        end
        curr = dequeue!(pq)
    end # while 


    curr = bestPath
    while !isempty(pq) && curr.potential > bestScore
        choices = findChoices(valves, vcat(curr.uSteps, curr.elSteps))
        if size(choices, 1) == 0
            if !isempty(pq)
                curr = dequeue!(pq)
                continue
            end
            break
        end

        uLast = curr.uSteps[end]
        elLast = curr.elSteps[end]
        for uChoice in choices
            uT = floywar.dists[uLast, uChoice] + 1
            next = createElPath(curr, uChoice, 0, uT, 0, flows, stop, floywar, valves)
            pq, bestScore, bestPath = addToPQ(pq, next, bestScore, bestPath, stop)
        end
        for elChoice in choices
            elT = floywar.dists[elLast, elChoice] + 1
            next = createElPath(curr, 0, elChoice, 0, elT, flows, stop, floywar, valves)
            pq, bestScore, bestPath = addToPQ(pq, next, bestScore, bestPath, stop)
        end

        curr = dequeue!(pq)
    end

    println("Best Found Path-> U: $(bestPath.uSteps) El: $(bestPath.elSteps)")

    return bestScore
end


#=
=#
function createElPath(curr, uChoice, elChoice, uT, elT, flows, stop, floywar, valves)
    next = nothing
    if uChoice != elChoice && curr.uTime + uT < stop && curr.elTime + elT < stop
        next = ElPaths(curr.uSteps, curr.uTime, curr.elSteps, curr.elTime, 0, curr.score)

        if uChoice != 0
            next.uSteps = vcat(next.uSteps, uChoice)
            next.uTime += uT
            next.score += (stop - next.uTime)flows[uChoice]

        end

        if elChoice != 0
            next.elSteps = vcat(next.elSteps, elChoice)
            next.elTime += elT
            next.score += (stop - next.elTime)flows[elChoice]
        end

        potential = next.score
        choices = findChoices(valves, vcat(next.elSteps, next.uSteps))
        potential += calcPotential(next, choices, floywar, flows, stop)
        next.potential = potential

    end # if
    return next
end

#=
=#
function addToPQ(pq, next, bestScore, bestPath, stop)
    if !isnothing(next) && next.uTime < stop && next.elTime < stop
        enqueue!(pq, next, next.potential)
        if next.score > bestScore
            bestScore = next.score
            bestPath = next
        end
    end # if
    return pq, bestScore, bestPath
end

#=
=#
function calcPotential(elpath, choices, floywar, flows, stop)
    lastEl = elpath.elSteps[end]
    lastU = elpath.uSteps[end]
    sum = 0
    for val in choices

        eldist = floywar.dists[val, lastEl] + 1 + elpath.elTime
        udist = floywar.dists[val, lastU] + 1 + elpath.uTime
        t = eldist < udist ? eldist : udist
        sum += (stop - t) * flows[val]

    end
    return sum
end