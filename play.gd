extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_go_back():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title.tscn")

func _on_mouse_entered() -> void:
	$hover.play()

func _on_mouse_exited() -> void:
	$leave.play()
