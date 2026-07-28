class_name HealthInteractionComponent extends InteractionComponent

@export var damage_info: DamageInfo

func _interact(_event: AreaEntityEvent) -> void:
	if active:
		entity.raise_local(DamageEntityEvent.new(self, damage_info, entity))

func _on_area_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.target_components.has(get_script().get_global_name()):
		area = event.source
		area.set_collision_layer_value(2, true)
