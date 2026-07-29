class_name HealthInteractionComponent extends InteractionComponent

@export var damage_info: DamageInfo

func _interact(event: CollisionEntityEvent) -> void:
	if event.data is InteractionData:
		event.data.source.raise_local(DamageEntityEvent.new(self, damage_info, entity))

func _on_area_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source.get_groups().has("custom_collision_object") and event.source is CollisionObject3D:
		collision_shape = event.source as CollisionObject3D
		collision_shape.cset_collision_layer_value(2, true)
