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
signal player_death(count)

@export var player_skin: Node2D
@export var bomb: PackedScene

@export var audio: AudioStreamPlayer2D
@export var jump_sound: AudioStream
@export var djump_sound: AudioStream

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -400.0

@export var max_jumps = 2

var state = states.STILL

var jump_count: int = 0
var is_right: bool = false

var spawn_point: Vector2

var max_bombs: int = 3
var bombs_left: int = 3

var deaths: int = 0

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
		elif Input.is_action_just_pressed("reset"):
			kill = true
		if kill and state != states.DEAD:
			state = states.DEAD
			deaths += 1
			state_change.emit(state)
			player_death.emit(deaths)
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
			
		if is_on_floor(): jump_count = 0
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			jump_count += 1
			if jump_count <= max_jumps:
				velocity.y = JUMP_VELOCITY
				if jump_count == 1:
					audio.stream = jump_sound
					audio.play()
				else:
					audio.stream = djump_sound
					audio.play()

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
	
