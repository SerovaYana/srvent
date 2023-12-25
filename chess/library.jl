using HorizonSideRobots
HSR = HorizonSideRobots

function try_move!(robot, side)
    ortogonal_side = leftside(side)
    back_side = inverse(ortogonal_side)
    n=0
    while isborder(robot, side)==true && isborder(robot, ortogonal_side) == false
        move!(robot, ortogonal_side)
        n += 1
    end
    if isborder(robot,side)==true
        along!(()->false, robot, back_side, n)
        return false
    end
    move!(robot, side)
    if n > 0
        along!(()->!isborder(robot, back_side), robot, side) 
        along!(()->false,robot, back_side, n)
    end
    return true
end

function HSR.move!(robot, side::Any)
    for s in side
        move!(robot, s)
    end
end

HSR.isborder(robot, side::Tuple{HorizonSide, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2]) # проверка isborder для 2 сторон
inverse(side) = HorizonSide(mod(Int(side)+2, 4)) # разворот стороны на 180
leftside(side) = HorizonSide(mod(Int(side)+1, 4)) # разворот налево
rightside(side) = HorizonSide(mod(Int(side)-1, 4)) # разворот направо
inverse(side::Tuple{HorizonSide, HorizonSide}) = inverse.(side) #разворот на 180 для всех сторон кортежа
leftside(side::Tuple{HorizonSide, HorizonSide}) = leftside.(side) #разворот налево для всех сторон кортежа
rightside(side::Tuple{HorizonSide, HorizonSide}) = rightside.(side) #разворот направо для всех сторон кортежа

function along!(stop_condition::Function, robot, side::HorizonSide) # идем до упора в заданную сторону
    steps = 0
    while !stop_condition() && try_move!(robot, side)
        steps += 1
    end   
    return steps
end

function along!(stop_condition::Function, robot, side, max_steps) # метод along!, идем заданное кол-во шагов в заданную сторону
    steps = 0
    while steps < max_steps && !stop_condition() && try_move!(robot, side)
        steps += 1
    end
    return steps
end

function mark_row!(robot, side) # закрашиваем линию в заданном направлении до упора
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

function mark_row!(robot, side, steps) # маркируем линию опред. длины
    putmarker!(robot)
    for i in 1:(steps-1)
        if !isborder(robot, side)
            move!(robot, side)
            putmarker!(robot)
        else
            return along!(()->false, robot, inverse(side), i-1)
        end
    end
    along!(()->false, robot, inverse(side), steps-1)
end
 

function to_start_position!(robot) # идем в левую нижнюю точку и запоминаем путь в массив
    steps_array = []
    num = 1
    while !isborder(robot, Sud) | !isborder(robot, West)
        num += 1
        side = HorizonSide(mod(num, 2) + 1)
        steps = 0
        while !isborder(robot, side)
            move!(robot, side)
            steps += 1
        end
        push!(steps_array, (inverse(side), steps))
    end
    return reverse(steps_array)
end

function num_steps_markline!(robot, side) # маркируем в заданном направлении до упора и возвращаем пройденное кол-во шагов
    steps = 0
    while try_move!(robot, side)
        putmarker!(robot)
        steps += 1
    end
    return steps  
end

function num_steps_markline!(robot, side::Tuple) # маркируем в заданном направлении до упора и возвращаем пройденное кол-во шагов
    steps = 0
    side1, side2 = side
    while try_move!(robot, side1) && try_move!(robot, side2)
        putmarker!(robot)
        steps += 1
    end
    return steps  
end

function shuttle!(stop_condition::Function, robot, side) # Задача номер 7 - находим дырку в большой перегородке 
    len_step = 1
    while !stop_condition()
        along!(()->isborder(robot, side),robot, side, len_step)
        len_step += 1
        side = inverse(side)
    end
end

function snake!(stop_condition::Function, robot, start_side, ortogonal_side) # Робот ходит змейкой, обходя простые препятствия
    s = start_side
    along!(stop_condition, robot, s)
    while !stop_condition() && try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(stop_condition, robot, s)
    end
end

function spiral!(stop_condition::Function, robot, side) # Задача номер 8 - СПИРАЛЬ
    len_steps = 1
    while !stop_condition()
        along!(stop_condition, robot, side, len_steps)
        side = leftside(side)
        along!(stop_condition, robot, side, len_steps)
        side = leftside(side)
        len_steps += 1
    end
end

abstract type AbstractRobot end # создаем абстрактный тип робота

mutable struct CountmarkersRobot <: AbstractRobot # создаем робота-счетчика_мареков, который относится к абстракному типу
    robot::Robot
    num_markers::Int64
end
 
get_baserobot(robot::CountmarkersRobot) = robot.robot

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

function HSR.move!(robot::CountmarkersRobot, side) 
    move!(robot.robot, side)
    if ismarker(robot)
        robot.num_markers += 1
    end
    nothing
end

mutable struct Coordinates
    x::Int
    y::Int
end

struct ChessRobotN <: AbstractRobot
    robot::Robot
    coordinates::Coordinates
    N::Int
    ChessRobotN(r,n) = new(r, Coordinates(0,0), N)
end

function HSR.move!(coord::Coordinates, side::HorizonSide)
    if side == Ost coord.x += 1
    elseif side == West coord.x -= 1
    elseif side == Nord coord.y += 1
    else coord.y -=  1
    end
end

get(coord::Coordinates) = (coord.x, coord.y)
get_baserobot(robot::ChessRobotN) = robot.robot

function HSR.move!(robot::ChessRobotN, side)
    move!(robot.robot, side)
    move!(robot.coordinates, side)
    x, y = get(robot.coordinates) .÷ N
    if ((abs(x) % 2) == 0 && (abs(y) % 2) == 0) || ((abs(x) % 2) == 1 && (abs(y) % 2) == 1)
        putmarker!(robot)
    end
end