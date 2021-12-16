extends KinematicBody2D

class_name Player

export var MOVE_SPEED = 100

func _physics_process(_delta: float) -> void:
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(x_input, y_input) * MOVE_SPEED)
