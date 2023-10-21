extends MeshInstance3D

func interact(interacter: Node3D) -> void:
	interacter.get_node("HealthComponent").decrease_health(50)
