class_name HealthInteractionComponent extends InteractionComponent

@export var on_hit_info: OnHitInformation

func _interact(interacter: Entity) -> void:
	if interacter.has_component(HealthComponent):
		interacter.get_component(HealthComponent).update_health(on_hit_info)
