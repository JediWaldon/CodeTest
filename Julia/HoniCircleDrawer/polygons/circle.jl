#=
drawCircle returns the points of a circle with the center at the coordinates (x, y)
@param r is the radius
@param x is the x position
@param y is the y position
=#
function circle(r, x, y)
    theta = LinRange(0, 2 * pi, 500)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

#=
=#
function drawCircle()
    plot(circle(1, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
end

#=
=#
function poly(r, p, x, y, offset=0)
    theta = LinRange(offset, 2 * pi + offset, p + 1)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

#=
=#
function drawPoly(p)
    plot(poly(1, p, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
end