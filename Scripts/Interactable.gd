extends StaticBody3D
class_name Interactable

func interact(interacter: Node3D) -> void:
	get_parent().interact(interacter)
