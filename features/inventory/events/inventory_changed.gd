class_name InventoryChangedEvent extends Event

var data: InventoryData

func _init(source_: Node, data_: InventoryData) -> void:
	super(source_)
	data = data_
