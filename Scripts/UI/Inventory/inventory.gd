class_name Inventory extends PanelContainer

const Slot: PackedScene = preload("res://Resources/Inventory/inventory_slot.tscn")
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid
func _ready() -> void:
	var inv_data = preload("res://Resources/Inventory/inventory_data.tres")
	populate_inv(inv_data.all_slot_data)

func populate_inv(slots: Array[SlotData]) -> void: 
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in slots:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
