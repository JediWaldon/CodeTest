include("../polygons/circle.jl");

#=
drawOddStar returns the points for any star with an odd number of points.
=#
function oddStar(r, p, x, y)
    theta = LinRange(0, 4 * pi, p + 1)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

#=
=#
function drawOddStar(p)
    plot(oddStar(1, p, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
end

#=
TODO: Recursion!
=#
function evenStar(r, p, offset, x, y)
    theta = LinRange(offset, 4 * pi + offset, p + 1)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

#=
TODO: Recursion!
=#
function drawEvenStar(p, offset=0)
    @show(offset * 6 / pi)
    if p == 4
        if offset == 0
            drawPoly(4)
        else
            plot!(poly(1, 4, 0, 0, offset), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
        end
    elseif p % 2 == 1
        if offset == 0
            drawOddStar(p)
        else
            plot!(evenStar(1, p, offset, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
        end
    else
        if offset == 0
            offset = 2 * pi / p
            drawEvenStar(fld(p, 2))
            drawEvenStar(fld(p, 2), offset)

        else
            offset1 = offset + offset / 2
            drawEvenStar(fld(p, 2), offset1)
            offset2 = offset - offset / 2
            drawEvenStar(fld(p, 2), offset2)
        end
        # drawOddStar(fld(p, 2))

        # plot!(evenStar(1, fld(p, 2), 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
    end
end