class_name HealthInteractionComponent extends InteractionComponent

@export var damage_info: DamageInfo

func _interact(event: CollisionEntityEvent) -> void:
	if event.data is InteractionData:
		var data: InteractionData = event.data as InteractionData
		if !data.hover:
			event.data.source.raise_local(DamageEntityEvent.new(self, damage_info, entity))

func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	pass
