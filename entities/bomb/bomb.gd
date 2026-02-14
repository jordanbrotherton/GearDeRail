extends CharacterBody2D

@export var explosion: PackedScene
@export var rubble: PackedScene
@export var area: Area2D
@export var col_shape: CollisionShape2D

@export var fuse_length: float = 0.5

const SPEED = 500.0

var move: float

## Sets the direction and starts the time for the bomb.
func set_speed(is_right) -> void:
	move = SPEED if is_right else -SPEED
	var timer = Timer.new()
	add_child(timer)
	timer.start(fuse_length)
	timer.timeout.connect(_explode)
	
func _physics_process(delta: float) -> void:
	var col = get_last_slide_collision()
	if col:
		_explode()
	
	velocity.x = move
	move_and_slide()
	
## bomb goes boom! [br]
## In all seriousness, it causes an explosion, with lots of cell destruction!.
func _explode():
	var cam = get_viewport().get_camera_2d()
	if cam and cam.has_method("start_shake"):
		cam.start_shake()
	
	var e = explosion.instantiate()
	e.global_position = global_position
	get_parent().add_child(e)
	for t in area.get_overlapping_bodies():
		if t is TileMapLayer:
			for cell in t.get_used_cells():
				var local_position = t.to_global(t.map_to_local(cell))
				if Geometry2D.is_point_in_circle(local_position,col_shape.global_position,(col_shape.shape.radius * scale.x)):
					var c = t.get_cell_tile_data(cell)
					if c.has_custom_data("breakable"):
						var r = rubble.instantiate()
						r.global_position = local_position
						get_parent().add_child(r)
						t.set_cell(cell, -1)
		queue_free()
