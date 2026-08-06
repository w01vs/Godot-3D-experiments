class_name PlayerInventoryLoadedEvent extends Event

var data: InventoryData
var bindings: InventoryBindings
var hotbar_data: InventoryData

func _init(source_: Node, data_: InventoryData, bindings_: InventoryBindings, hotbar_data_: InventoryData) -> void:
	super(source_)
	data = data_
	bindings = bindings_
	hotbar_data = hotbar_data_
