extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var DASH_VELOCITY = 1000

var is_dashed: bool = false
var is_right: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_dashed = false
		elif !is_dashed:
			is_dashed = true
			if is_right:
				velocity.x = move_toward(DASH_VELOCITY, 0, SPEED)
			else: velocity.x = move_toward(-DASH_VELOCITY, 0, SPEED)

	is_right = false if velocity.x < 0 else true

	move_and_slide()
