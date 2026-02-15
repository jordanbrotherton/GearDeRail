extends Node2D


@export var train: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	await $Timer.timeout	
	var t = create_tween()
	t.tween_property(train, "position:x", -500, 2)
	await $Timer2.timeout
	get_tree().change_scene_to_file("res://title.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
