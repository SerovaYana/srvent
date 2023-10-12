include("func.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 7)
function mark_kross_x!(robot) 
    for side in [(Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
    putmarker!(robot)
end
mark_kross_x!(robot)