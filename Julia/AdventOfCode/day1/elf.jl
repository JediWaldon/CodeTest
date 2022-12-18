mutable struct Elf 
    id::Int
    arr::Array{Int}
    total::Int
end

#=
The constructElf function constructs a new elf
@param id is the id number of the elf
@param snack is the calorie value of the first snack the elf is carrying.
@return the new elf.
=#
function constructElf(id::Int, snack::Int)
    return Elf(id, [snack], snack)
end

#=
addCalories function adds calories to a given elf object.
@param e is the elf being added to.
@param snack is the number of calories being added to them.
=#
function addCalories(e::Elf, snack::Int)
    e.arr = hcat(e.arr, snack)
    e.total += snack
end

