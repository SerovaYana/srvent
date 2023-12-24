using HorizonSideRobots
include("func.jl")
robot = Robot("№23/23.sit", animate = true) 

function neib!(robot, side)
    if !try_move!(robot, side)
        move!(robot, left(side))
        neib!(robot, side)
        move!(robot, right(side))
    end
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

function along!(robot, side)
    if !isborder(robot, side)
        move!(robot,side)
        along!(robot, side)
    else
        neib!(robot,side)
    end
    move!(robot, side)
end
right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

along!(robot, Ost)