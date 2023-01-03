using Graphs
using DataStructures

#=
Problem:
We are in a series of tunnels that have access to 
pressure valves. The volcano is about to blow and 
we want to release as much pressure as possible 
using the valves to make the explosion tamer.

Part 1: 
Release as much pressure as you can in 30 minutes.

Part 2:
Release as much pressure as you can with an 
elephant companion in 26 minutes. Assume 
coordinated movements.
=#






#=
Part 1 data structure. 
@var steps tracks what steps have been taken on 
    the path.
@var time tracks the time that has passed while 
    executing the path.
@var potential is the potential pressure that 
    may be released by adding to the path.
@var flowrate is the flowrate of the path.
@var score is the amount of pressure released 
    at the current time step.
=#
mutable struct Path
    steps::Vector
    time::Int
    potential::Int
    flowrate::Int
    score::Int
end

#=
Part 2 data structure.
@var uSteps is the vector of steps you took.
@var uTime is the amount time that passed while 
    you were executing the path.
@var elSteps is the vector of steps the elephant took.
@var elTime is the amount of time that passed while
    the elephant was executing the path.
@var potential is the potential pressure that may be 
    released by going to other valves next on the path.
    (Different calculation than part 1)
@var score is the amount of pressure released by the 
    valves that are open when the time is up.
    (Different calculation than part 1)
=#
mutable struct ElPaths
    uSteps::Vector
    uTime::Int
    elSteps::Vector
    elTime::Int
    potential::Int
    score::Int
end



#=
lavaflow reads the hardcoded file and extracts the 
graph data and stores it in a SimpleGraph. It records 
the flowrate of every valve in a vector of flows. The 
names and indexes of the valves are stored in two 
hashtables which are each the inverse of the other. 
This is used to get our starting position as it is not 
always at the start of the input file. 

The hashtables are not the most efficient way to do this, 
but they allow for the program to print out the names of 
the valves instead of their line number in the input file. 
(This has not been done, currently ouputs the line number, 
but this is an easy fix.) The floyd_warshall_shortest_paths 
algorithm is called to simplify the graph so that the program 
does not waste time computing every step for valves that don't 
do anything. The algorihtm returns an object which contains a 
matrix of distances between each vertex of the graph.

A priority queue is constructed to contain the Path objects 
for part 1 and their potential. The reverse order is used so 
that the higher potentials are at the front of the queue rather 
than at the back, as would be the case with the default forward 
ordering. The useful valve ids are recorded in a vector and the 
start valve is added to the empty prirority queue. Part 1 gets 
executed by calling the part 1 function and the result is displayed. 

Then another priority queue is constructed using the same ordering 
as the previous but for ElPath objects and their potential. The start 
valve is enqueued and then the part2 function is executed and the 
result is displayed.
=#
function lavaflow()
    g = nothing
    table = Dict{Int,String}()
    rev = Dict{String,Int}()
    flows = []

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

    maxflow = sum(flows)
    start = Path([rev["AA"]], 0, maxflow * 30, 0, 0)
    enqueue!(pq, start, start.score)

    display(part1(pq, floywar, vec, 30, flows))

    elpq = PriorityQueue{ElPaths,Int}(Base.Order.Reverse)
    start = ElPaths([rev["AA"]], 0, [rev["AA"]], 0, maxflow * 26, 0)
    enqueue!(elpq, start, start.potential)
    display(part2(elpq, floywar, vec, 26, flows))
end


#=
part1 finds the maximum amount of pressure that can be releived 
in the given time. The priority queue contains the start position 
which is stored in the curr variable by peeking (dequeuing it 
messes up the while loop). The maximum flowrate is calculated 
off of the flows vector and is used to calculate the potential of 
each path. At the start the best score and best path have not 
been found.

While the priority is not empty and the current path's potential 
is not less than the best score the function have seen and there 
are still valves not in the path the following will occur. 
Potential choices for the path to continue are found. From the 
current position try all next steps and add the new paths to the 
priority queue.

The potential calculation uses the assumption that all valves 
are instantly opened the moment the current value is opened and 
score of the path plus the remaining time with all valves opened 
in the potential. The time of the path and score of the path are 
updated before this occurs.

If there is time left the path is enqueued and if a new best score 
is found it is recorded and so is the path. 

After one of the stop conditions is met the best path's score is 
increased so that it reflects the amount of pressure released by 
the end of the time allowed. The best path is printed and the 
score is returned.

@param pq is the priority queue of paths taken.
@param floywar is the floyd_warshall_shortest_paths result used 
    for the distance between valves.
@param valves is the vector of useful valves for quick reference.
@param stop is the time limit.
@param flows is the vector of flow rates of all the valves by id.

@return the best score found.
=#
function part1(pq::PriorityQueue{Path,Int}, floywar, valves, stop, flows)
    curr = peek(pq)[1]
    maxflow = sum(flows)
    bestScore = 0
    bestPath = nothing

    while !isempty(pq) && curr.potential > bestScore && size(curr.steps, 1) - 1 != size(valves, 1)

        choices = findChoices(valves, curr.steps)

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
findChoices is the function that returns the options a 
given path has for a next step.

@param valves is the vector of all useful valves.
@param steps is all the valves that have been visited.

@return the vector of choices for the next step.
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
part2 is the function that solves the case where you are 
partnering with an elephant that you taught how to open 
valves. To begin the function peeks at the priority queue 
to set the current path. (Dequeuing messes uo the while 
loop. Could be solved using a do while.) 

While the priority queue is not empty and the curr path's 
potential is greater than the best score found do the 
following: Find all the choices for the next step that 
you and the elephant can take. Find the distance to each 
one and add all possible combinations of the steps to the 
priority queue. Then dequeue the next path to check.

After exiting the while loop, there still might be steps 
to take as the previous while loop forces both parties to 
take a step. To finish off finding a path, set the current 
path to the best path and then enter another while loop that 
only goes a single valve for either you or the elephant. Add 
these to the queue and record the best score and best path.

Print out the best path for both you and the elephant. 
(They are interchangable) 

Return the best score.

@param pq is the priority queue of ElPaths.
@param floywar is the result of the floyd_warshall_shortest_paths 
which contains the distance matrix used to find the time taken 
to open valves.
@param valves is the vector of useful valves.
@param stop is the time limit.
@param flows is the vector of flows of the valves by id.

@return the best score.
=#
function part2(pq::PriorityQueue{ElPaths,Int}, floywar, valves, stop, flows)
    curr = peek(pq)[1]
    bestScore = 0
    bestPath = nothing
    # t = 1

    while !isempty(pq) && curr.potential > bestScore
        choices = findChoices(valves, vcat(curr.uSteps, curr.elSteps))

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

        # Check that the function is actually doing useful things if the problem is really big.
        # Fun Julia trick to update a variable while using it in another context.
        # if (t += 1) % 10000 == 0
        #     println("Score: $bestScore")
        # end
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
createElPath is a function for creating new 
ElPath objects. If the ElPath doesn't have you 
and the elephant going to the same place copy 
the old ElPath and update all the fields to 
match the paths taken. If the choice for either 
you or the elephant is zero this means there 
isn't an update to that path so keep the old 
values. Calculate potential based off of the 
distance to the next valves individally. (Via 
the calcPotential function) Return the object 
constructed or nothing. 

@param curr is the old ElPath.
@param uChoice is the next step that you are 
    taking on your path. If it is 0 this means 
    you didn't move.
@param elChoice is the next step that the 
    elephant is taking on its path. If it is 0 
    this means it didn't move.
@param uT is the time you spent travelling to 
    and opening the valve.
@param elT is the time the elephant spent 
    travelling to and opening the valve.
@param flows is the vector of flows for all 
        useful valves.
@param stop is the time limit.
@param floywar is the result of the 
    floyd_warshall_shortest_paths which contains 
    the matrix of distances between the valves.
@param valves is the vector of all the useful 
    valves ids.

@return the new ElPath object created or nothing.
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
addToPQ is the function that adds ElPath 
objects to the priority queue. As long as 
the next ElPath isn't nothing and both 
paths don't exceed the time limit the 
ElPath is enqueued and compared against 
the best score. If it is better it is 
recorded and the best path is updated. 
Return the priority queue, the best score, 
and the best path.

@param pq is the priority queue of ElPaths.
@param next is the ElPath is the being 
    evaluated.
@param bestScore is the current best score.
@param bestPath is the current bestPath.
@param stop is the time limit.

@return the priority queue, the best score 
    and the bestPath.
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
calcPotential is the function that computes the 
potential of an ElPath. The last steps on the 
path and recorded then all possible choices are 
evaluated as if the one closest to them (you or 
the elephant) went to them and opened them next. 
The sum of the potentials for all the next 
possible steps is then returned.

@param elpath is the current elpath.
@param choices is the vector of valves that have 
    not yet been visited.
@param floywar is the result of the 
    floyd_warshall_shortest_paths algorithm which 
    contains a matrix of the distances between 
    all the valves.
@param flows is the vector of all the flow rates 
    of all the valves.
@param stop is the time limit.

@return the sum of the potential scores from 
    going to every possible next choice from the 
    closest position.
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