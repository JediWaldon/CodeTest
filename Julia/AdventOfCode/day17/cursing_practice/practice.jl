horline = ['@' '@' '@' '@']
plus = ['.' '@' '.'; '@' '@' '@'; '.' '@' '.']
revl = ['.' '.' '@'; '.' '.' '@'; '@' '@' '@']
verline = ['@' '.'; '@' '.'; '@' '.'; '@' '.']
square = ['@' '@'; '@' '@']

shapes = [horline, plus, revl, verline, square]

function practice()
    foreach(shape -> draw(shape2string(shape), spaces()), shapes)
    print(stdout, "$(spaces())\u001b[H")
end

function draw(str::String, blank::String)
    # dims = dims(shape)
    print(stdout, "$(blank)\u001b[H")
    print(stdout, "$(str)\u001b[H")
    sleep(1.0)

end

function shape2string(shape)
    str::String = ""
    dims = size(shape)
    for i in 1:dims[1]
        for j in 1:dims[2]
            if shape[i, j] != '.'
                str = str * shape[i, j]
            else
                str = str * ' '
            end
        end
        str = str * '\n'
    end
    return str
end

function spaces()
    str::String = ""
    for i in 1:100
        for j in 1:100
            str = str * " "
        end
        str = str * '\n'
    end
    return str
end