class_name PlayerInventoryLoadedEvent extends Event

var data: InventoryData
var bindings: InventoryBindings

func _init(source_: Node, data_: InventoryData, bindings_: InventoryBindings) -> void:
	super(source_)
	data = data_
	bindings = bindings_
