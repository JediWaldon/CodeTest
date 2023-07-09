include("shapes/circle.jl");
include("shapes/star.jl");
include("stick/stick.jl");

function honi(args::String; p::Int=0, t::Int=1, o::Float64=0.0, r::Float64=1.0, x::Float64=0.0, y::Float64=0.0)
    if (args == "circle")
        draw(circle())
    elseif args == "star" && p >= 3 && p >= 1
        draw(star(p, tight=t, offset=o, xpos=x, ypos=y, rad=r))
        # elseif args == "star" && p != 0 && p % 2 == 0
        #     draw(evenStar(p))
        # elseif args == "poly" && p >= 3
        #     draw(poly(p))
        # elseif args == "star" && p % 2 == 1
        #     draw(star(p))
    elseif args == "new"
        clear()
    end
end