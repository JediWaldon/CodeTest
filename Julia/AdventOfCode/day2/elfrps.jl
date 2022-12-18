#=
The elves are playing Rock, Paper, Scissors.
You are given a sheet to follow and score.
=#

#=
evalRound calculates the results of a single round of the game.
@param results is a matrix containing the point results of the player's action and the opponent's action.
@param response is a matrix of the action to take to if the goal is to win, draw, or lose against a given action from the opponent.
@param opp is a character representing the opponent's action
@param res is a character representing the goal of this exchange, to win, draw, or lose.
=#
function evalRound(results::Matrix{Float64}, response::Matrix{Float64}, opp::Char, res::Char)
    oppNum = opp - 'A' + 1
    resNum = res - 'X' + 1
    if (oppNum > 3 || oppNum < 1) || (resNum > 3 || resNum < 1)
        error("Invalid character")
    end
    k = Int64(response[oppNum, resNum])
    return results[oppNum, k]
end

#=
comMatrix constructs a matrix of the point values for players taking certain actions.
@return the matrix containing the point values.
=#
function comMatrix()
    res = zeros(3, 3)
    for i = 1:3
        for j = 1:3
            if j - i == 1 || i - j == 2
                res[i, j] = j + 6
            elseif i == j
                res[i, j] = j + 3
            else
                res[i,j] = j
            end
        end
    end
    return res
end

#=
respMatrix constructs a matrix containing the actions the user must take in order to acheive a victory, draw, or loss against the opponent's action.
@return the matrix of responding actions
=#
function respMatrix()
    resp = zeros(3,3)
    for i = 1:3
        for j = 1:3
            resp[i,j] = (i + j) % 3 + 1
        end
    end
    return resp
end

#=
main analyzes the hardcaoded document and calculates the score of the user.
@return the score of the user.
=#
function main()
    results = comMatrix()
    response = respMatrix()
    score = 0
    open("/Users/jeddywaldon/CodeTest/Julia/AdventOfCode/day2/input.txt") do io
        while !eof(io)
            line = readline(io)
            if length(line) != 3
                error("Unexpected line type")
            end
            score += evalRound(results, response, line[1], line[3])
        end
    end
    return score
end