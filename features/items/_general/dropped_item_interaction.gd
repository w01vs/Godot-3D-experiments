class_name DroppedItemInteractionComponent extends InteractionComponent

var item: ItemData
var quantity: int

func set_data(item_: ItemData, quantity_: int) -> void:
	item = item_
	quantity = quantity_

func _interact(event: CollisionEntityEvent) -> void:
	if event.data is InteractionData:
		if event.data.source.has_component(InventoryComponent):
			var inv: InventoryComponent = event.data.source.get_component(InventoryComponent)
			if inv.add_item(item, quantity) <= 0:
				entity.queue_free()
