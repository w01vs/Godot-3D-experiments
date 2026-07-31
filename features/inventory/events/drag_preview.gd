class_name DragPreviewChangedEvent extends Event

var data: InventoryUISlotData

func _init(source_: Node, data_: InventoryUISlotData) -> void:
	super(source_)
	data = data_
