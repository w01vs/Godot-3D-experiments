class_name ChestInteraction extends InteractionComponent

var inv: InventoryComponent

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	if entity.has_component(InventoryComponent):
		inv = entity.get_component(InventoryComponent)
	else:
		push_error("Chest interaction requires an InventoryComponent but could not find one.")
		assert(false)

func _interact(event: CollisionEntityEvent) -> void:
	if event.data is InteractionData:
		var data: InteractionData = event.data
		if !data.hover:
			entity.raise_local(InventoryOpenEntityEvent.new(self, false))
			data.source.raise_local(SetPlayerContextEntityEvent.new(self, PlayerContext.State.INVENTORY))

func _on_collision_shape_registered(_event: CollisionShapeRegisteredEntityEvent) -> void:
	pass
