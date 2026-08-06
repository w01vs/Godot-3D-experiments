class_name InventoryData extends RefCounted

var data: Dictionary[int, InventoryUISlotData]
var size: int
var hotbar: bool

func _init(data_: Dictionary[int, InventoryUISlotData], size_: int, hotbar_: bool = false) -> void:
	data = data_
	size = size_
	hotbar = hotbar_
