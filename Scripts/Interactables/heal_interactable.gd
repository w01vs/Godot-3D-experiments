extends Node3D

func interact(interacter: Node3D) -> void:
	interacter.get_node("HealthComponent").increase_health(50, true, 2, 10)
