include("/Users/jeddywaldon/CodeTest/Julia/DnD/Initiative.jl")


#=
The test function will test the Initiative file and print out its progress.
=#
function test()
    i = 1
    init = enterInitiative()
    allpass= true

    # Test that the initiaive is empty
    if isEmpty(init)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the removeCreature function fails
    if removeCreature(init, 1) == "Initiative is empty"
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the isTail function will fail
    if isTail(init, InitNode(nothing, nothing, nothing)) == "Initiative is empty"
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the isTop function will fail
    if isTop(init, InitNode(nothing, nothing, nothing)) == "Initiative is empty"
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test adding first new node
    node1 = addCreatureTo(init, 1, 20)
    if isTail(init, node1)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test adding second new node with higher priority 
    node2 = addCreatureTo(init, 2, 21)
    if isTop(init, node2)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the tail is the first node
    if isTail(init, node1)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test adding new node with lower priority 
    node3 = addCreatureTo(init, 3, 19)
    if isTop(init, node2)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the new node is the new tail
    if isTail(init, node3)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the initiative prints correctly
    if vecInit(init) == [2,1,3]
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    # Test that the nextTurn function updates the current field 
    res = nextTurn(init)
    if res != "Initiative is empty" && res.creature == 1
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test that the nextTurn function updates the current field to the last
    # node we added
    res = nextTurn(init)
    if res != "Initiative is empty" && res.creature == 3
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test that the nextTurn function will take it back to the top of the order
    res = nextTurn(init)
    if res != "Initiative is empty" && res.creature == 2
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test that the removeCreature function removes the desired node
    res = removeCreature(init, 3)
    if res == node3
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Confirm previous test
    if isTail(init, node1)
        println("Pass test $i")
    else
        println(init.tail)
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test that the removeCreature function will fail properly.
    res = removeCreature(init, 3)
    if res == "Node not found"
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test that the removeCreature function can remove the first element
    res = removeCreature(init, 2)
    if res == node2
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Confirm previous test
    if isTop(init, node1)
        println("Pass test $i")
    else
        println(init.top)
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Test remove last
    res = removeCreature(init, 1)
    if res == node1
        println("Pass test $i")
    else
        println("Fail test $i")
        allpass = false
    end
    i += 1

    # Confirm  previous test
    if isEmpty(init)
        println("Pass test $i")
    else 
        println("Fail test $i")
        allpass = false
    end 
    i += 1

    return allpass ? "All tests passed!" : "Something failed!"
end