class_name MouseMotionInputEvent extends CustomInputEvent

var relative: Vector2
var screen_relative: Vector2

func _init(source_: Node, relative_: Vector2, screen_relative_: Vector2) -> void:
		super(source_)
		relative = relative_
		screen_relative = screen_relative_
