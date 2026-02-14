class_name TrainCar
extends Sprite2D

signal player_done

@export var door_l: Node2D
@export var door_r: Node2D

@export var area: Area2D

@export var foreground: ColorRect
@export var color: Color

@export var level_node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Emplaces the next level inside the car.
func place_level(level: PackedScene) -> void:
	var lvl = level.instantiate()
	level_node.add_child(lvl)

## This should be when the car is currently active and focused on the camera.
func focus() -> void:
	var t = create_tween()
	t.tween_property(foreground, "color", Color(color, 0), 0.5)
	door_r.unfocus()
	door_l.unfocus()
	area.set_deferred("monitoring", true)

## Called when the car is off to the side and is purely a prop.
func unfocus() -> void:
	var t = create_tween()
	t.tween_property(foreground, "color", color, 0.5)
	for child in level_node.get_children():
		level_node.remove_child(child)
		child.queue_free()
	door_r.focus()
	door_l.unfocus()
	area.set_deferred("monitoring", false)

## See if the player reached the next car.
func _on_area_hit(body: Node2D) -> void:
	if body is Player:
		player_done.emit()
