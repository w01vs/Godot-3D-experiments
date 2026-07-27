class_name HealthInteractionComponent extends InteractionComponent

@export var on_hit_info: OnHitInformation

func _interact(_event: AreaEntityEvent) -> void:
	if active:
		entity.raise_local(DamageEntityEvent.new(self, on_hit_info))

func _on_area_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.target_component == get_script().get_global_name():
		area = event.source
		area.set_collision_layer_value(2, true)
