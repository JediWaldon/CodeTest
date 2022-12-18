# Finds the stack depth the machine is allowed to go to.
# Assumes that it doesn't optimize and use tail-recursion.
# I've run it and force quit it at 60,000 or so.
function stackDepth(i::Int)
    println("Current Depth:$i")
    stackDepth(i+1)
end