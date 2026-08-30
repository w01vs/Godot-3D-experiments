class_name ItemFloatComponent extends Component

var data: InventorySlotData
@export var area: CArea3D

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	area.cset_collision_mask_value(CollisionLayer.TERRAIN, true)
	area.cset_collision_mask_value(CollisionLayer.STRUCTURE, true)
