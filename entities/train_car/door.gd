extends StaticBody2D

@export var sprite: ColorRect
@export var col: CollisionShape2D
@export var color: Color

## Opens the door.
func focus():
	var t = create_tween()
	t.tween_property(sprite, "color", color, 0.5)
	col.set_deferred("disabled", false)
	
## Closes the door.
func unfocus():
	var t = create_tween()
	t.tween_property(sprite, "color", Color(color, 0), 0.5)
	col.set_deferred("disabled", true)
