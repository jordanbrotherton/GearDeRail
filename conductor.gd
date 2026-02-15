extends Node2D

@export var levels: Array[PackedScene]

@export var left_car: TrainCar
@export var active_car: TrainCar
@export var right_car: TrainCar

@export var front_car: CompressedTexture2D

@export var train_width: float = 829.5

func _ready() -> void:
	if active_car:
		if len(levels) > 0:
			var lvl = levels.pop_front()
			active_car.place_level(lvl)
			active_car.area.set_deferred("monitoring", true)
			active_car.door_l.focus()

## Triggers the change to the next level.
func change_level() -> void:
	if left_car:
		left_car.visible = true
	if right_car:
		$Camera2D.change_target(right_car)
		var temp = active_car
		active_car = right_car
		right_car = left_car
		left_car = temp
	if active_car is Sprite2D:
		right_car.position.x += train_width*3
	if len(levels) > 0:
		var lvl = levels.pop_front()
		active_car.place_level(lvl)
	if len(levels) == 0:
		active_car.texture = front_car
		active_car.door_r.focus()
		right_car.queue_free()

func _on_player_done() -> void:
	change_level()
