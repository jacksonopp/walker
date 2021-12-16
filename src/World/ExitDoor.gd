extends Area2D

signal leaving_level

func _on_ExitDoor_body_entered(_body: Node) -> void:
	emit_signal("leaving_level")
