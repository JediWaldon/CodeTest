#=
The star function calculates the positions of the points of a star of a given number of vertices. This is further modified by how tight the star is, how large the radius of the star is, where on the coordinate plane it is and how much it is rotated.

@param p is the number of points in the star.
@param tight is a keyword argument for the tightness of the star 
    ranging from one to one less than half of p.
@param rad is the keyword argument for the radius of the star.
@param xpos is the keyword argument for the x position of the center of the star.
@param ypos is the keyword argument for the y position of the center of the star.
@param offset is the keyword argument for how much the star is rotated.
=#
function star(p::Int; tight::Int, rad::Float64=1.0, xpos::Float64=0.0, ypos::Float64=0.0, offset::Float64=0.0)
    if tight <= (p - 1) / 2 && tight >= 1
        theta = LinRange(offset, tight * 2 * pi + offset, p + 1)
        return xpos .+ rad * sin.(theta), ypos .+ rad * cos.(theta)
    else
        return ErrorException("Invalid tightness.")
    end
end

# #=
# oldStar returns the points for any star with an odd number of points.
# =#
# function oldStar(p, r::Float64=1.0, x::Float64=0.0, y::Float64=0.0)
#     theta = LinRange(0, 4 * pi, p + 1)
#     x .+ r * sin.(theta), y .+ r * cos.(theta)
# end

# #=
# =#
# function drawOddStar(p)
#     plot(oddStar(1, p, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
# end

# #=
# TODO: Recursion!
# =#
# function evenStar(p, r::Float64=1.0, x::Float64=0.0, y::Float64=0.0, offset=0.0)
#     theta = LinRange(offset, 4 * pi + offset, p + 1)
#     # @show(offset * 180 / pi)
#     x .+ r * sin.(theta), y .+ r * cos.(theta)
# end

# #=
# TODO: Recursion!
# =#
# function drawEvenStar(p, offset=0.0)
#     # @show(offset * 6 / pi)
#     if p == 4
#         if offset == 0
#             drawPoly(4)
#         else
#             draw(poly(4, offset=offset))
#             # plot!(poly(1, 4, 0, 0, offset), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
#         end
#     elseif p % 2 == 1
#         if offset == 0
#             drawOddStar(p)
#         else
#             draw(evenStar(p, offset=offset))
#             # plot!(evenStar(1, p, offset, 0, 0), seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
#         end
#     else
#         if offset == 0
#             offset = 2 * pi / p
#             drawEvenStar(fld(p, 2))
#             drawEvenStar(fld(p, 2), offset)

#         else
#             offset1 = offset
#             drawEvenStar(fld(p, 2), offset1)
#             offset2 = offset * 3
#             drawEvenStar(fld(p, 2), offset2)
#         end

#     end
# end

# #=
# =#
# # function pieces(p)
# #     original = p
# #     while p % 2 != 1 && p != 4
# #         p /= 2
# #     end
# #     return convert(Int, original / p)
# # end