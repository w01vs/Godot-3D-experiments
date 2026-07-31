class_name InventorySlotClickedUIEvent extends UIEvent

var panel: InventoryPanel
var index: int

func _init(source_: Node, panel_: InventoryPanel, index_: int) -> void:
	super(source_)
	panel = panel_
	index = index_
