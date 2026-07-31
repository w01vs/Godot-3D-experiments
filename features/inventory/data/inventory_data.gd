class_name InventoryData extends RefCounted

var data: Dictionary[int, InventoryUISlotData]
var size: int

func _init(data_: Dictionary[int, InventoryUISlotData], size_: int) -> void:
	data = data_
	size = size_
