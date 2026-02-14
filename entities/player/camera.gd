extends Camera2D

@export var focus_target: Node2D
@export var shake_factor: float = 20.0

@export var shake_length: float = 5

@onready var rand = RandomNumberGenerator.new()

var shake_process: float 

func _process(delta: float) -> void:
	global_position = focus_target.global_position
	shake_process = lerp(shake_process, 0.0, shake_length * delta)
	
	offset = _get_shake_offset()
	
func _get_shake_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_process, shake_process),
		rand.randf_range(-shake_process, shake_process)
	)

	
func start_shake() -> void:
	shake_process += shake_factor
