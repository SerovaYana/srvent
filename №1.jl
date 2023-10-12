include("func.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 7)
function mark_kross!(robot)
    for side in [Nord, Ost, Sud, West]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
    putmarker!(robot)
end
mark_kross!(robot)