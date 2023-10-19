extends Node
class_name Interactable

func get_interaction_text() -> String:
	return "Interact"
	
	
func interact(interacter: Node) -> void:
	#print("Interacted with %s" % name)
	get_parent().interact(interacter)
