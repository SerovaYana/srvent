using HorizonSideRobots
include("func.jl")
robot = Robot("№20/20.sit", animate = true)

function along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        along!(robot, side)
        move!(robot, inverse(side))
    else
        putmarker!(robot)
    end
end

function inverse(side)
    if side == Nord
        return Sud
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else
        return Ost
    end
end

along!(robot, West)