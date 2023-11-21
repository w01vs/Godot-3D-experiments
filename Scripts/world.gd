class_name World extends Node3D

func _ready() -> void:
	GlobalRefs.map = get_world_3d().navigation_map
