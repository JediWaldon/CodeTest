#=
The roll4d6drop function rolls 4d6 and drops the lowest before returning 
the dice result and the total. 
@return the dice result and total for a single stat.
=#
function roll4d6drop()
    arr = Vector{Int}(undef,4)
    lowest = 6
    sum = 0
    for i = 1: length(arr)
        roll = rand(1:6)
        arr[i] = roll
        if roll < lowest
            lowest = roll
        end
        sum += roll
    end
    return arr, sum - lowest
end

#=
The roll3d6 function rolls 3d6 and returns the dice result and the total.
@return the dice result and the total for a single stat.
=#
function roll3d6()
    arr = Vector{Int}(undef, 3)
    sum = 0
    for i = 1: length(arr)
        roll = rand(1:6)
        arr[i] = roll
        sum += roll
    end
    return arr, sum
end

#=
The fixedOrder function produces a fixed order array of stats and dice results.
@param f is the rolling function the fixedOrder function uses to generate stats.
@return the pair of dice results and stat results in the order they were rolled.
=#
function fixedOrder(f::Function) 
    dieArr = Array{Vector}(undef, 1, 6)
    statArr = Array{Int}(undef, 1, 6)
    for i = 1:6
        dieArr[i], statArr[i] = f()
    end
    return dieArr, statArr
end

#=
The sortedOrder function produces a pair of matrices with the stat array inside.
@param f is the rolling function used to produce the stat arrays.
@return the dice roll array and the stat array.
=#
function sortedOrder(f::Function)
    dieArr = Array{Vector}(undef, 1, 6)
    statArr = Array{Int}(undef, 1, 6)
    for i = 1:6
        dieArr[i], statArr[i] = f()
    end
    for j = 1:6
        for k = 1:6
            if statArr[j] > statArr[k]
                swap(statArr, dieArr, j, k)
            end
        end
    end
    return dieArr, statArr
end

#=
The swap function swaps the values of the specified elements of the arrays
@param arr1 is the first array with elements to be swapped
@param arr2 is the second array with elements to be swapped
@param j is the first index of an item to be swapped
@param k is the second index of an item to be swapped
=#
function swap(arr1, arr2, j, k)
    val1 = arr1[j]
    val2 = arr2[j]
    arr1[j] = arr1[k]
    arr2[j] = arr2[k]
    arr1[k] = val1
    arr2[k] = val2
end