class_name DropItemEvent extends Event

var item: ItemData
var quantity: int
var position: Vector3

func _init(source_: Node, item_: ItemData, quantity_: int, position_: Vector3) -> void:
	super(source_)
	item = item_
	quantity = quantity_
	position = position_
