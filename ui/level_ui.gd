extends Control

@export var bomb_label: Label
@export var death_label: Label
@export var time_label: Label

var time_elapsed: float = 0.0
var is_count: bool = false	

var lvl_count = false

func update_bomb(count):
	bomb_label.text = str(count)


func _on_player_death(count: Variant) -> void:
	death_label.text = str(count)
	
func stop_the_count():
	is_count = false
	
func start_the_count():
	is_count = true

func _process(delta: float) -> void:
	if is_count:
		time_elapsed += delta
		time_label.text = str(time_elapsed).pad_decimals(2)

func _on_train_car_level_changed(spawn: Variant, level: Variant) -> void:
	if !lvl_count:
		lvl_count = true
	else:
		start_the_count()
