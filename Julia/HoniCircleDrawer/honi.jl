using Plots;
gr();
include("polygons/circle.jl");
include("nonpolygons/star.jl");

function main(args::String, p::Int=0)
    if (args == "circle")
        drawCircle()
    elseif args == "star" && p % 2 == 1
        drawOddStar(p)
    elseif args == "star" && p != 0 && p % 2 == 0
        drawEvenStar(p)
    elseif args == "poly" && p >= 3
        drawPoly(p)
    end
end