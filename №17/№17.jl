using HorizonSideRobots
include("func.jl")
robot = Robot("№17/17.sit", animate = true)

function spiral!(stop_condition::Function, robot)
    max_num_steps = 1
    side = Nord
    while !stop_condition(robot)
        num_steps = 0
        while num_steps < max_num_steps && !stop_condition(robot)
            move!(robot, side)
            num_steps += 1
        end
        side = left(side)
        num_steps = 0
        while num_steps < max_num_steps && !stop_condition(robot)
            move!(robot, side)
            num_steps += 1
        end
        max_num_steps += 1
        side = left(side)
    end
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

spiral!(ismarker, robot)