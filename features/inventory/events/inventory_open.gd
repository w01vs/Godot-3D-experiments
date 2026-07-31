class_name InventoryOpenUIEvent extends UIEvent

var static_inventory: InventoryData
var bindings: InventoryBindings

func _init(source_: Node, bindings_: InventoryBindings, static_inventory_: InventoryData = null) -> void:
		super(source_)
		bindings = bindings_
		static_inventory = static_inventory_
