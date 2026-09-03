class_name HealthInteractionComponent extends InteractionComponent

@export var damage_info: DamageInfo

func _interact(event: CollisionEntityEvent) -> void:
	if event.data is InteractionData:
		var data: InteractionData = event.data as InteractionData
		if !data.hover:
			event.data.source.emit_local(DamageEntityEvent.new(self, damage_info, entity))
