#=
distressSig reads the hardcoded file and records the content as 
vectors of any kind so that they can contain both integers and 
vectors. It calls parseVector to read each line and then calls 
compareAny to see if the pair of vectors are in the right order 
in the file. If they are, the index the pair is located at is 
added to the sum in order to report the answer for part 1. 
Part 2 is computed by adding in two new vectors as markers and 
calling bubble to sort the vector of all the vectors. The markers 
are then found and their indices are multiplied to the tracker 
for part 2. The tuple of part 1 and part 2 answers are returned.
@return the tuple of answers for part 1 and part 2.
=#
function distressSig()
    idx = 1
    vec = []
    sum = 0
    open(pwd() * "/Julia/AdventOfCode/day13/input.txt") do io
        while !eof(io)
            line = readline(io)
            left = parseVector(line[2:end-1])
            vec =  vcat(vec, 1)
            vec[size(vec,1)] = left
            
            # println("$line\n$left")

            line = readline(io)
            right = parseVector(line[2:end-1])
            vec =  vcat(vec, 1)
            vec[size(vec,1)] = right
            # println("$line\n$right")

            if !eof(io)
                readline(io)
            end

            if compareAny(left, right)
                sum += idx
            end
            idx += 1
        end
    end
    m1 = [[2]]
    m2 = [[6]]
    vec = vcat(vec, 1)
    vec[size(vec,1)] = m1
    vec = vcat(vec, 1)
    vec[size(vec,1)] = m2
    vec = bubble(vec)

    mult = 1
    for i = 1:size(vec,1)
        if vec[i] == m1 || vec[i] == m2
            mult *= i
            if vec[i] == m2
                break
            end
        end
    end
    return sum, mult
end

#=
compareInt compares two integers. If the left is smaller than
the right it returns true to indicate that they are in the 
right order. If the left is larger than the right it returns 
false to indicate that they are not in the right order. 
Otherwise it returns nothing.
@param left is the integer on the left.
@param right is the integer on the right.
@return true if the left and right are in the right order. 
False if they are in the wrong order. Nothing if it both 
numbers are the same.
=#
function compInt(left::Int, right::Int)
    if left > right
        return false
    elseif left < right
        return true
    end
    return nothing
end

#=
compList takes two vectors of integers and tests to see if 
they are in the right order. It iterates simultaneously 
through both vectors and compares the elements one by one. 
compareInt is called for each iteration to test if the left 
and right vectors are in the right order. If this results 
in a response other than nothing the response will be returned. 
Otherwise the vector that runs out of elements should be on 
the left. If the right runs out of elements first then compList 
returns false to indeicate they are not in the right order. If 
the left runs out of elements first true is returned as the 
elements are in the right order. Otherwise nothing is returned.
@param left is the left list.
@param right is the right list.
@return true if the lists are in the right order, false if they 
are not, and nothing if both lists are identical.
=#
function compList(left::Vector, right::Vector)
    leflen = size(left, 1)
    riglen = size(right, 1)
    for i = 1:leflen
        if i > riglen
            return false
        end
        r = compInt(left[i], right[i])
        if !isnothing(r) && !r
            return false
        elseif !isnothing(r) && r
            return true
        end
    end
    if leflen < riglen
        return true
    end
    return nothing
end

#=
compareAny takes two arguments of unknown type and determines 
whether they are in the right order. It determines the types 
of the arguments and then reacts accordingly. If it can, it 
will pass them to compareInt or compList. Otherwise it will 
recursively call itself for the vector elements of the vectors 
given to it, iterating through both vectors simultaneously. In 
the case that the elements of the vectors match but one ends 
early, if the shorter one is on the left, the function returns 
true, if the one on the right ends first, return false. If both 
are equal, then return nothing.
@param left is the left vector.
@param right is the right vector.
@return true if the left and right are in the right order, false 
if they are not, and nothing if it cannot be determined.
=#
function compareAny(left, right)
    tyl = typeof(left)
    tyr = typeof(right)
    if tyl == Int64 && tyr == Int64
        # println('1')
        return compInt(left, right)
    elseif tyl == Vector{Int64} && tyr == Vector{Int64}
        # println('2')
        return compList(left, right)
    elseif tyl == Int64 && tyr == Vector{Int64}
        # println('3')
        return compList([left], right)
    elseif tyl == Vector{Int64} && tyr == Int64
        # println('4')
        return compList(left, [right])
    elseif tyl == Int64 && tyr == Vector{Any}
        # println('5')
        return compareAny([left], right)
    elseif tyl == Vector{Any} && tyr == Int64
        # println('6')
        return compareAny(left, [right])
    elseif tyl == Int64
        # println('7')
        return compList([left], right)
    elseif tyr == Int64
        # println('8')
        return compList(left, [right])
    else
        # println("9")
        leflen = size(left, 1)
        riglen = size(right, 1)
        for i = 1:leflen
            if i > riglen
                return false
            end
            r = compareAny(left[i], right[i])
            if !isnothing(r) && r
                return true
            elseif !isnothing(r) && !r
                return false
            end
        end
        if riglen > leflen
            return true
        end
    end

end

#=
parseVector reads a string character by character and builds a 
vector. If it encounters brackets it will keep track of how 
many it sees and will count down until it sees a matching 
closing bracket. It will then call itself recursively on that 
segment of the string. If it sees integers in the vector it 
will keep track of them until it sees a ',' or the string ends 
before adding them to the vector.
@param string is the string representing the vector.
@return the vector generated.
=#
function parseVector(string::String)
    vec = []
    len = sizeof(string)
    unsee = false
    sdx = 0
    count = 0 
    edx = 0
    val = 0
    for i = 1:len
        if string[i] == '['
            if sdx == 0
                sdx = i
                unsee = true
            else
                count += 1
            end
        elseif string[i] == ']'
            if count == 0
                unsee = false
                edx = i - 1
                str = string[sdx + 1:edx]
                val = parseVector(str)
                if i == len
                    vec = vcat(vec, 1)
                    vec[size(vec,1)] = val
                end
            else
                count -= 1
            end
        elseif !unsee && string[i] == ','
            vec = vcat(vec, 1)
            vec[size(vec,1)] = val
            sdx = 0
            count = 0 
            edx = 0
            val = 0
        elseif !unsee
            val *= 10
            val += parse(Int, string[i])
            if i == len
                vec = vcat(vec, val)
            end
        end
    end
    return vec
end

#=
bubble works like BubbleSort for this vector. It will pass through the vector of vectors and compare them using compareAny. If it returns false for a pair of vectors that are adjacent in the vector it will swap their positions and ensure that it does another pass. It will keep making passes until it no longer has to swap any elements. It will do this at most n times where n is the length of the vector This gives it a worse case runtime of O(n^2). The sorted vector of vectors is returned.
@param vec is the vector to be sorted.
@return vec in its sorted form.
=#
function bubble(vec::Vector{Any})
    len = size(vec, 1)
    pass = true
    for i = 1:len
        for j = 1:len - 1
            if !compareAny(vec[j], vec[j + 1])
                hold = vec[j]
                vec[j] = vec[j+1]
                vec[j+1] = hold
                pass = false
            end
        end
        if pass
            break
        end
    end
    return vec
end