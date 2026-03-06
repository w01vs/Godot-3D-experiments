class_name Hotbar extends Control

@onready var grid: GridContainer = $MarginContainer/ItemGrid
var slot: PackedScene = preload("res://Scenes/Inventory/inventory_slot.tscn")
var slots: Array[InventorySlot] = []

func _ready() -> void:
	if GlobalRefs.player:
		initialise()
	else:
		GlobalRefs.player_set.connect(initialise)
	
func initialise() -> void:
	GlobalRefs.player.inventory.inventory_changed.connect(update_slot)
	GlobalRefs.player.inventory.hotbar_active_changed.connect(set_active_slot)
	slots.resize(GlobalRefs.player.inventory.HOTBAR_SIZE)
	for i in range(slots.size()):
		slots[i] = slot.instantiate()
		slots[i].target = "hotbar"
		slots[i].index = i
		grid.add_child(slots[i])
	display_inventory(GlobalRefs.player.inventory.hotbar_slots)

func set_active_slot(index: int) -> void:
	pass

func display_inventory(data: Array[SlotData]) -> void:
	for i in range(data.size()):
		slots[i].set_data(data[i])

func update_slot(index: int, data: SlotData, target: String) -> void:
	if target == "hotbar":
		slots[index].set_data(data)
