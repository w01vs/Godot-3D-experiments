class_name ItemStack extends Resource

@export var item_data: ItemData
@export var quantity: int

func _init(item: ItemData = null, quantity_: int = 0) -> void:
	item_data = item
	quantity = quantity_
