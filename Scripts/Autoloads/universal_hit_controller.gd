extends Node

var health_component: HealthComponent

func apply_information_to(info: OnHitInformation, body: Node3D) -> void:
	if info:
		for n in info.groups.size():
			if body.is_in_group(info.groups[n]):
				health_component = body.get_node("HealthComponent")
				if info.has_healing_info and health_component:
					health_component.increase_health(info.heal)
				if info.has_damage_info and health_component:
					health_component.decrease_health(info.damage * info.damage_multiplier)
				if info.has_position_effect_info:
					pass
