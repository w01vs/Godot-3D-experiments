class_name Inventory extends Node

signal inventory_changed(index: int, data: SlotData)

var INVENTORY_SIZE: int = 12

var slots: Array[SlotData] = []

func _ready() -> void:
	var inv_data = preload("res://Resources/Inventory/inventory_data.tres")
	slots.resize(INVENTORY_SIZE)
	slots.fill(null)
	for i in range(inv_data.all_slot_data.size()):
		set_slot_data(i, inv_data.all_slot_data[i])

func set_slot_data(index: int, data: SlotData) -> void:
	slots[index] = data
	inventory_changed.emit(index, data)
