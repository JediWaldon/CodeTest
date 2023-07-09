using Plots;
gr();
# #=
# =#
# function startDraw(details::Tuple{Vector{Float64},Vector{Float64}})
#     plot(details, seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
# end

#=
=#
function draw(details::Tuple{Vector{Float64},Vector{Float64}})
    plot!(details, seriestype=[:shape,], lw=1.0, linecolor=:black, fillalpha=0.15, legend=false, aspect_ratio=1)
end

function clear()
    plot()
end