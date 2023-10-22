extends Node

var health_component: HealthComponent
var groups

func apply_information_to(info: OnHitInformation, body: Node3D) -> void:
	groups = info.groups
	for n in info.groups.size():
		if body.get_groups().any(filter_groups):
			print_debug(body.name)
			health_component = body.get_node("HealthComponent")
			if info.has_healing_info and health_component:
				health_component.increase_health(info.heal)
			if info.has_damage_info and health_component:
				health_component.decrease_health(info.damage * info.damage_multiplier)
			if info.has_position_effect_info:
				pass


func filter_groups(group: String) -> bool:
	for n in groups.size():
		if groups[n] == group:
			return true
	return false
