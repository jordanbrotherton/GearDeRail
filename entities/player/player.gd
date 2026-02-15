class_name Player
extends CharacterBody2D

enum states{
	STILL,
	MOVING,
	BOMB,
	JUMP,
	DEAD
}

signal state_change(state: states)
signal player_respawn(pos)
signal bomb_count_changed(bombs)

@export var player_skin: Node2D
@export var bomb: PackedScene

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -400.0

var state = states.STILL

var is_jumped: bool = false
var is_right: bool = false

var spawn_point: Vector2

var max_bombs: int = 3
var bombs_left: int = 3

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if get_last_slide_collision() and state != states.DEAD:
		var col = get_last_slide_collision().get_collider()
		var kill = false
		if col is EnemyMover:
			kill = true
		elif col is TileMapLayer and col.name == "damages":
			kill = true
		if kill and state != states.DEAD:
			state = states.DEAD
			state_change.emit(state)
			var t = Timer.new()
			add_child(t)
			t.start(2)
			await t.timeout
			player_respawn.emit(global_position)
			global_position = spawn_point
			state = states.STILL
			bombs_left = max_bombs
			bomb_count_changed.emit(bombs_left)

	if state != states.DEAD:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = (direction * SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				is_jumped = false
			elif !is_jumped:
				velocity.y = JUMP_VELOCITY
				is_jumped = true

		if Input.is_action_just_pressed("bomb"):
			if bombs_left > 0:
				bombs_left -= 1
				var n = bomb.instantiate()
				n.global_position = global_position
				if is_right:
					n.global_position.x += 30
				else: n.global_position.x -= 30
				get_parent().add_child(n)
				n.set_speed(is_right)
				bomb_count_changed.emit(bombs_left)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	update_state()

	var was_right = is_right
	if velocity.x > 0: is_right = true
	elif velocity.x < 0: is_right = false
	if was_right != is_right:
		#player_skin.scale.x *= -1
		$PlayerSkin.swap_side(is_right)
	move_and_slide()

func update_state():
	var current = state
	if state != states.DEAD:
		if abs(velocity.x) > 0:
			state = states.MOVING
		else: state = states.STILL
		
		if !is_on_floor():
			state = states.JUMP

		if current != state:
			state_change.emit(state)


func _on_level_changed(spawn: Variant, level: Level) -> void:
	spawn_point = spawn
	max_bombs = level.bombs
	bombs_left = max_bombs
	bomb_count_changed.emit(bombs_left)
	
