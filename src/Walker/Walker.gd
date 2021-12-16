extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
#const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.DOWN]



var position := Vector2.ZERO
var direction := Vector2.RIGHT
var borders := Rect2()
var step_history := []
var steps_since_turn := 0
var max_room_size := 0
var min_room_size := 0
var rooms := []

func _init(starting_pos: Vector2, new_borders: Rect2, min_size: int, max_size: int) -> void:
	assert(new_borders.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_borders
	max_room_size = max_size
	min_room_size = min_size
	
func walk(steps: int) -> Array:
	place_room(position)
	for step in steps:
#		if randf() > 0.75 and steps_since_turn >= 4:
		if steps_since_turn >= 6:
			change_direction()
		
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history
	
#Moves the walker in a direction, returns true if its possible
func step() -> bool:
#	Calculate which direction we want to go
	var target_pos = position + direction
	
#	Turn if its not within the border
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false
	
func change_direction():
	place_room(position)
#	Reset steps
	steps_since_turn = 0
	
#	Get the new possible directions
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	
#	Get the first direction from array
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
	
func create_room(room_position: Vector2, size: Vector2) -> Dictionary:
	var rect = Rect2(position, size)
	var start = rect.position
	var end = rect.end
	var center = Vector2((start.x + end.x)/2, (start.y + end.y)/2)
	return {position = room_position, size = size, center = center}

func place_room(room_position: Vector2):
	var size := Vector2(randi() % max_room_size + min_room_size, randi() % max_room_size + min_room_size)
	var top_left_corner := (room_position - size / 2).ceil()
	rooms.append(create_room(room_position, size))
	for y in size.y:
		for x in size.x:
			var new_step
			if step_history.size() == 0:
				new_step = top_left_corner + Vector2(2, 2)
			else:
				new_step = top_left_corner + Vector2(x, y)				
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room() -> Dictionary:
	var end_room = rooms.pop_front()
	var starting_pos: Vector2 = step_history.front()
	for room in rooms:
		if starting_pos.distance_to(room.position) > starting_pos.distance_to(end_room.position):
			end_room = room
			
	return end_room
