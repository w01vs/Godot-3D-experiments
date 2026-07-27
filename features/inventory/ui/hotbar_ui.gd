class_name Hotbar extends Control

@onready var grid: GridContainer = $MarginContainer/ItemGrid
@export var slot: PackedScene

var slots: Array[InventorySlot] = []
var active_hotbar_index: int = -1
func _ready() -> void:
	return
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
	if active_hotbar_index != -1:
		slots[active_hotbar_index].toggle_border(false)
	active_hotbar_index = index
	slots[index].toggle_border(true)

func display_inventory(data: Array[SlotData]) -> void:
	for i in range(data.size()):
		slots[i].set_data(data[i])

func update_slot(index: int, data: SlotData, target: String) -> void:
	if target == "hotbar":
		slots[index].set_data(data)
