# I ran into an issue with part 2 because I tried to use BigInts. 
# I switched to moduloing by the least common denominator while 
# waiting for my code to finish running. A fellow Adventist had posted 
# a video of someone they watched doing the Advent of Code for that day.
# This is where I learned I could use the lcm instead of running in BigInt.
# Very useful thing to learn.
using DataStructures # Using a Queue for convenience.

#=
The monkey struct is used as a model for the following problem.
items tracks the items the monkey is carrying as a queue.
operation is the function that performs the operation on our worry level.
base is the base the test function uses to check our worry level.
test is the function that decides where the monkey throws the item they are examining.
inspected keeps track of the number of items the monkey has inspected.
=#
mutable struct Monkey
    items::Queue{Int}
    operation::Function
    base::Int
    test::Function
    inspected::Int
end

#=
The readFile function reads the file containing the monkeys and 
what they will do. It computes the least common denominator and passes 
it on to the function running the rounds. 
@param rounds is the number of rounds to evaluate.
@return the two greatest inspected values from the monkeys 
multiplied together.
=#
function readFile(rounds)
    monkeylist = Vector{Monkey}()
    open(pwd() * "/Julia/AdventOfCode/day11/input.txt") do io
        while !eof(io)
            monkeylist = vcat(monkeylist, createMonkey(io))
        end

    end

    # compute the least common denominator 
    lcmult = lcm(monkeylist)
    for i = 1:rounds
        round(monkeylist, lcmult)
    end

    # find the two greatest values of items the monkeys have inspected.
    greatest = 0
    second = 0
    for i = 1: size(monkeylist, 1)
        num = monkeylist[i].inspected
        if num > greatest
            second = greatest
            greatest = num
        elseif num > second
            second = num
        end
    end
    # showItems(monkeylist)
    # showInspected(monkeylist)
    return greatest * second
end




#=
createMonkey creates a monkey by reading the file and taking 
the useful pieces of data out. 
@param io is the io stream to read the file.
=#
function createMonkey(io)
    line = readline(io)

    # Find the items the monkey is holding
    line = readline(io)
    itemslist = parse.(Int, split(line[18:length(line)], ','))
    items = Queue{Int}()
    for i = 1: size(itemslist, 1)
        items = enqueue!(items, itemslist[i])
    end

    # Find the operation of the monkey
    line = readline(io)[24:end]
    symbol = line[1]
    operation = nothing
    if line[3:end] == "old"
        operation = old -> oper(old, symbol, old)
        # println("old $symbol old")
    else
        num = parse(Int, line[3:end])
        # println("old $symbol $num")
        operation = old -> oper(old, symbol, num)
    end

    # Find the decision of the monkey
    testnum = parse(Int, readline(io)[21:end])
    truecond = parse(Int, readline(io)[29:end])
    falsecond = parse(Int, readline(io)[30:end])
    test = (monkeylist, worry) -> throw(monkeylist, worry, testnum, truecond, falsecond)

    # Check to get rid of blank space.
    if !eof(io)
        readline(io)
    end
    
    # Return the monkey constructed
    return Monkey(items, operation, testnum, test, 0)
end

#=
turn models the monkey on its turn. While it has items it will examine them and then throw them to their fellows based on their test function.
@param monkey is the monkey who is taking their turn.
@param monkeylist is the list of monkeys participating.
@param lcm is the least common denominator which is used to monitor worry levels.
=#
function turn(monkey::Monkey, monkeylist, lcm)
    while !isempty(monkey.items)
        # Monkey looks at the item at the front of the queue
        worry = dequeue!(monkey.items)
        
        # Originally worry was divided by three, but not after a while
        # Item is undamaged, and worry is divided by 3
        # worry = fld(monkey.operation(worry), 3)

        # Update worry value
        worry = monkey.operation(worry) % lcm

        # Monkey decides who to throw to
        monkey.test(monkeylist, worry)
        monkey.inspected += 1
    end
end

#=
round runs the round of the game the monkeys are playing with our stuff.
It runs through the list of monkeys and has each of them take a turn.
@param monkeylist is the list of monkeys.
@param lcm is the least common denominator of the monkey's test bases.
=#
function round(monkeylist, lcm)
    for i = 1:size(monkeylist, 1)
        turn(monkeylist[i], monkeylist, lcm)
    end
end

#=
oper is the function constructor for the monkey's operation function.
@param old is the worry value of function.
@param symbol is the operator symbol being used in the function.
@param change is the chagne being done when the function is called.
@return the new worry level.
=#
function oper(old, symbol, change)
    if symbol == '*'
        return old * change
    elseif symbol == '+'
       return old + change
    else
        error("Unexpected symbol: \'$symbol\'")
    end
end

#=
throw is the constructor function for the monkey's test function.
@param monkeylist is the list of monkeys in the game.
@param worry is our worry level.
@oaram base is the base for deciding the monkey's actions.
@param target1 is the target who gets the item if the test is true.
@param target2 is the target who gets the item if the test is false.
=#
function throw(monkeylist, worry, base, target1, target2)
    # println("worry: $worry, base: $base")
    if worry % base == 0
        enqueue!(monkeylist[target1 + 1].items, worry)
    else
        enqueue!(monkeylist[target2 + 1].items, worry)
    end
end

#=
showInspected is the function that displays the how many items the monkey's have inspected.
@param monkeylist is the list of monkeys in the game.
=#
function showInspected(monkeylist)
    for i = 1: size(monkeylist, 1)
        display(monkeylist[i].inspected)
    end
end

#=
showItems is the function that displays the monkeys items worry levels.
@param monkeylist is the list of monkeys in the game.
=#
# function showItems(monkeylist)
#     for i = 1: size(monkeylist, 1)
#         display(monkeylist[i].items)
#     end
# end

#=
lcm is the function that finds the lowest common denominator of the list of bases for the monkeys.
@param m is the list of monkeys in the game.
@return the least common denominator 
=#
function lcm(m)
    lcm = 1
    for i=1:size(m, 1)
        lcm *= m[i].base
    end
    return lcm
end