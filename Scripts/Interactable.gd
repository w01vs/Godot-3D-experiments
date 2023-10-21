extends Node
class_name Interactable

func get_interaction_text() -> String:
	return "Interact"
	
	
func interact(interacter: Node3D) -> void:
	get_parent().interact(interacter)
