extends MeshInstance3D

func interact(interacter: Node) -> void:
	interacter.get_node("HealthComponent").increase_health(10)
