class_name ChestInteraction extends InteractionComponent

var inv: InventoryComponent

@export var interactable_area: CArea3D

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
			ContextManager.push_player_state(PlayerContext.State.STATIC_INVENTORY)

func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source == interactable_area:
		interactable_area.cset_collision_mask_value(CollisionLayer.ENTITY, true)
		interactable_area.body_exited.connect(_range_check)
		interactable_area.monitoring = true


func _range_check(body: Node3D) -> void:
	if body is CCharacterBody3D and inv.is_open():
		var p_entity: Entity = body.entity
		if p_entity.has_component(PlayerComponent):
			entity.raise_local(InventoryCloseEntityEvent.new(self))
			ContextManager.pop_player_state()
