using DataStructures

# Creatures are going to be the vlaues in our queue.
q = Queue{String}()
l = Dict{String,Int}()

function main()
    println("Welcome to Initiative Tricks! This program is used to change the initatives of creatures in initiative mid-combat for Dungeons and Dragons 5e.")

    collection()

    display(l)

    run_combat()
end

function collection()
    go_on = true
    while go_on
        print("Creature name: ")
        name = readline()
        print("Creature initiative: ")
        num_str = readline()
        io = stdout::IO
        while isnothing(tryparse(Int64, num_str))
            printstyled(IOContext(io, :color => true), "Not a number. \nPlease enter an integer: ", color=:red)
            num_str = readline()
        end
        io = nothing
        num = parse(Int64, num_str)
        # while typeof(num) != Int64
        #     print("Not a number. \nPlease enter an integer: ")
        #     num_str = readline()
        #     num = parse(Int64, num_str)
        # end
        # println("Name: $name \nType: $(typeof(num)) \nValue: $num")

        # TODO: Collect initiative number here
        # TODO: Add string and number pair to dictionary 
        l[name] = num
        print("Continue? (q to quit): ")
        res = readline()
        if res[1] == 'q' || res[1] == 'Q'
            go_on = false
        end


        # TODO: collect input

    end
end

function run_combat()
    # TODO
end

function alter_init()
    # TODO
end