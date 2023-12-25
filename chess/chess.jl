include("library.jl")

N = parse(Int64, readline())
robot = ChessRobotN(Robot(animate=true, "task14.sit"), N)
waytostart = to_start_position!(robot)
snake!(()->false, robot, Ost, Nord)
to_start_position!(robot)
for i in waytostart
    along!(()->false, robot, i[1], i[2])
end