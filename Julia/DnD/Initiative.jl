# InitNode is the a node in the circular list called Initiative
mutable struct InitNode 
    creature
    roll
    next
end

# Initiative is a circular list that keeps critical records
mutable struct Initiative
    top::InitNode
    current::InitNode
    tail::InitNode
    length::Int
end

#= 
Initialize the empty initiative
@return the empty initiative
=#
function enterInitiative()
    empty = InitNode(nothing, nothing, nothing)
    return Initiative(empty, empty, empty, 0)
end

#=
The addCreatureTo function adds a creature to the initiative.
@param init is the initiative the creature is being added to.
@param creature is the creature being added to the initiative.
@param roll is the initiative roll of the creature.
@return the new creature's node.
=#
function addCreatureTo(init::Initiative, creature, roll::Int) 
    newCreature = InitNode(creature, roll, nothing)
    if isEmpty(init)
        newCreature.next = newCreature
        init.top = newCreature
        init.tail = newCreature
        init.current = newCreature
        init.length += 1
        return newCreature
    end
    current = init.top
    while !isnothing(current)
        if newCreature.roll >= current.roll || isTop(init, current.next)
            newCreature.next = current.next
            current.next = newCreature
            init.length += 1
            if newCreature.roll > init.top.roll
                init.top = newCreature
                init.current = newCreature
            end
            if isTop(init, newCreature.next)
                init.tail = newCreature
            end
            break
        end
        current = current.next
    end
    return newCreature
end

#=
The isEmpty function returns true if the initiative is empty and false otherwise.
@param init is the intiative.
@return true if the initiative is the empty and false otherwise.
=#
function isEmpty(init::Initiative) 
    return init.length == 0
end

#=
The isTop function returns true if the node is the top of the initiative.
@param init is the intiative.
@param node is the node being checked against the top of the intiative.
@return true if the node is the one at the top of the initiative and a string otherwise.
=#
function isTop(init::Initiative, node::InitNode)
    if isEmpty(init)
        return "Initiative is empty"
    end
    return init.top == node
end

#=
The isTail function returns true if the node is the tail of the initiative.
@param init is the intiative.
@param node is the node being checked against the tail of the initiative.
@return true if the node is the one at the tail of the initiative and a string otherwise.
=#
function isTail(init::Initiative, node::InitNode)
    if isEmpty(init)
        return "Initiative is empty"
    end
    return init.tail == node
end

#=
The vecInit function constructs a vector of creatures and returns it in the order of the intiative.
@param init is the initiative. 
@return the vector of the initiative creatures.
=#
function vecInit(init::Initiative)
    str = []
    current = init.top
    for i = 1:init.length
        str = vcat(str, current.creature)
        current = current.next
    end 
    return str
end

#=
The nextTurn function moves the current pointer in the initiative 
to the next one in the initiative.
@param init is the intiative.
@return the current node in the initiative.
=#
function nextTurn(init::Initiative)
    if isEmpty(init)
        return "Initiative is empty"
    end
    init.current = init.current.next
    return init.current
end

#=
The removeCreature function removes a creature from the initiative and 
rearranges the initiative after removing the creature.
@param init is the initiative being modified.
@param creature is the creature being removed.
@return the removed node or a string communicating an error.
=#
function removeCreature(init::Initiative, creature)
    if isEmpty(init)
        return "Initiative is empty"
    end
    node = nothing
    current = init.tail
    next = init.top
    for i = 0: init.length
        if next.creature == creature
            node = next
            if isTop(init, node)
                init.top = node.next
            end
            if isTail(init, node)
                init.tail = current
            end
            current.next = next.next
            init.length -= 1
            if init.length == 0
                init = enterInitiative()
            end
            return node
        end
        current = next
        next = next.next
    end
    return "Node not found"
end
