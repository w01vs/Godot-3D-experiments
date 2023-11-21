class_name Interactable extends StaticBody3D

func _ready() -> void:
	set_collision_layer_value(2, true)

func interact(interacter: Node3D) -> void:
	get_parent().interact(interacter)
