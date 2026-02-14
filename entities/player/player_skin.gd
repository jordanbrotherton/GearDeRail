extends Node2D

@export var sprite: AnimatedSprite2D

@export var anim: Array[SpriteFrames]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_state_change(state):
	match state:
		Player.states.STILL:
			sprite.animation = "still"

func swap_side(side: bool):
	sprite.sprite_frames = anim[int(side)]
