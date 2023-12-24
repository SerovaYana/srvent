using HorizonSideRobots
include("func.jl")
robot = Robot("№25/25.sit", animate = true)

function chess_line!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        no_delated_action!(robot, side)
    end
end
function no_delated_action!(robot, side)
    if !isborder(robot, side)
        putmarker!(robot)
        move!(robot, side)
        chess_line!(robot, side)
    else
        putmarker!(robot)
    end
end

chess_line!(robot, Nord)