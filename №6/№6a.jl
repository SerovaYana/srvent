include("func.jl")
robot = Robot("№6/6.sit", animate=true)

function mark_perimeter!(robot)
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end

function mark_border_perimeter!(robot)
    A = to_start_position!(robot)
    mark_perimeter!(robot)
    for i in A
        along!(robot, i[1], i[2])
    end
end

mark_border_perimeter!(robot)