#=
drawCircle returns the points of a circle with the center at the coordinates (x, y)
@param r is the radius
@param x is the x position
@param y is the y position
=#
function circle(r::Float64=1.0, x::Float64=0.0, y::Float64=0.0)
    theta = LinRange(0, 2 * pi, 500)
    x .+ r * sin.(theta), y .+ r * cos.(theta)
end

# #=
# =#
# function drawCircle(r::Float64=1.0, x::Float64=0.0, y::Float64=0.0)
#     plot(circle(r, x, y), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
# end

