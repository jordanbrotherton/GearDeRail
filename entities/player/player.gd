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

@export var player_skin: Node2D
@export var bomb: PackedScene

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -400.0

var state = states.STILL

var is_jumped: bool = false
var is_right: bool = false

var is_dead: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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
		var n = bomb.instantiate()
		n.global_position = global_position
		if is_right:
			n.global_position.x += 30
		else: n.global_position.x -= 30
		get_parent().add_child(n)
		n.set_speed(is_right)
		
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
	if abs(velocity.x) > 0:
		state = states.MOVING
	else: state = states.STILL
	
	if !is_on_floor():
		state = states.JUMP

	if is_dead:
		state = states.DEAD

	if current != state:
		state_change.emit(state)
