using HorizonSideRobots
include("func.jl")
robot = Robot("№19/19.sit",animate = true)

function along!(r,side)
    if !isborder(r,side)
        move!(r, side)
        along!(r,side)
    end    
end

along!(robot, West)