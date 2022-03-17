extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var room_list = []
var steps_since_turn = 0

func _init(start_position, new_borders):
	assert(new_borders.has_point(start_position))
	position = start_position
	step_history.append(position)
	borders = new_borders
	
func walk(steps):
	create_room(position)
	room_list.append(position)
	for step in steps:
		if steps_since_turn >= 6: # and randf() <= 0.5:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
			
	var wm = WorldMap.new(step_history, step_history.front(), step_history.back(), room_list)
	return wm
	
func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false
	
func change_direction():
	if randf() <= .4:
		create_room(position)
		room_list.append(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position):
	var size = Vector2(randi() % 3 + 3, randi() % 3 + 3)
	var top_left_corner = (position - size/2).ceil()
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)
