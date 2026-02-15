extends Button

func _ready():
	grab_focus()
	
	

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_go_back():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title.tscn")

func _on_mouse_entered() -> void:
	$hover.play()

func _on_mouse_exited() -> void:
	$leave.play()


func _on_visibility_changed() -> void:
	grab_focus()


func _on_focus_entered() -> void:
	_on_mouse_entered()


func _on_focus_exited() -> void:
	_on_mouse_exited()


func _on_credits_focus_entered() -> void:
	pass # Replace with function body.
