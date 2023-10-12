include("func.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 7)
function mark_perimeter!(robot)
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end
mark_perimeter!(robot)