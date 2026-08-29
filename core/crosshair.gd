extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_viewport_rect().get_center() - Vector2(size.x / 2, size.y / 2)
