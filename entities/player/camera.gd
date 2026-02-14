extends Camera2D

@export var focus_target: Node2D

func _process(delta: float) -> void:
	global_position = focus_target.global_position
