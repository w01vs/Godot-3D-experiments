extends Node3D
class_name World

func _ready() -> void:
	GlobalRefs.map = get_world_3d().navigation_map
