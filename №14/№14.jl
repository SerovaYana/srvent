using HorizonSideRobots

robot = Robot("№14/14.sit", animate = true)


try_move!(robot, side) = 
  if isborder(robot, side)
    return false
  else
    if ismarker(robot)
      move!(robot, side)
    else
      move!(robot, side)
      putmarker!(robot) 
    end
    return true
  end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

along!(stop_condition::Function, robot, side) = 
    while stop_condition() == false && try_move!(robot, side) end

function snake!(stop_condition::Function, robot, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Nord, Ost))
  along!(robot, move_side) do 
    stop_condition() || isborder(robot, move_side)
  end
  while !stop_condition() && try_move!(robot, next_row_side)
    move_side = inverse(move_side)
      along!(robot, move_side) do 
        stop_condition() || isborder(robot, move_side)
      end
  end
end

snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide}=(Ost, Nord)) =
  snake!(() -> false, robot, (next_row_side, move_side))

function move_with_steps!(robot, side, step)
  if ismarker(robot)
    move!(robot, side)
  else 
    move!(robot, side)
    putmarker!(robot)
  end
  step += 1
  return step
end

function InPoint(robot, step_sud, step_west)
  putmarker!(robot)
  while !isborder(robot, Sud)
    step_sud = move_with_steps!(robot, Sud, step_sud)
  end
  """if !ismarker(robot) && !isborder(robot, West)
    move!(robot, West)
  end"""
  while !isborder(robot, West)
    step_west = move_with_steps!(robot, West, step_west)
  end
  return step_sud, step_west
end

function point_to(robot)
  while !isborder(robot, Sud)
    move!(robot, Sud)
  end
  while !isborder(robot, West)
    move!(robot, West)
  end
end

function move_sum!(robot::Robot, side::HorizonSide, num::Int)
  for _ in 1:num
    move!(robot, side)
  end
end

function to_start(robot, step_sud, step_west)
  move_sum!(robot, Nord, step_sud)
  move_sum!(robot, Ost, step_west)
end

function main(robot)
  step_sud = 0
  step_west = 0
  step_sud, step_west = InPoint(r, step_sud, step_west)
  snake!(robot, (Ost, Nord))
  snake!(robot, (West, Nord))
  point_to(robot)
  to_start(robot, step_sud, step_west)
end

