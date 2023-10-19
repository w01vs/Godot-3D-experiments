extends MeshInstance3D


func _ready() -> void:
	pass

func interact(interacter: Node) -> void:
	interacter.get_node("HealthComponent").decrease_health(10)
