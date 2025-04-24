extends Node

var health_component: HealthComponent

func apply_information_to(info: OnHitInformation, body: Node3D) -> void:
	if info:
		for n in info.groups.size():
			if body.is_in_group(info.groups[n]):
				health_component = body.get_node("HealthComponent")
				health_component.update_health(info)
