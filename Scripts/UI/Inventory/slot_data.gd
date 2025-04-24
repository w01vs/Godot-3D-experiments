class_name SlotData extends Resource


const MAX_STACK_SIZE: int = 10

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1
