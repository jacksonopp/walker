extends Node2D

func _physics_process(_delta: float) -> void:
	update()
	
func _draw() -> void:
	var forhead = get_parent().get_node("Position2D").position
	var exit = get_tree().get_nodes_in_group("LevelExit")[0]
	var exit_pos = exit.position
	var direction_to_exit = forhead.distance_to(exit_pos)
#	print(direction_to_exit)
##	draw_line(forhead, direction_to_exit, Color.red)
