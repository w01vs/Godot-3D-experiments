class_name Hotbar extends Control

var active_index: int

@onready var grid: GridContainer = $MarginContainer/ItemGrid

var slots: Array[InventorySlot] = []

func _ready() -> void:
	for slot in grid.get_children():
		if slot is InventorySlot:
			slots.append(slot)
	active_index = 0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("scroll_down"):
		if active_index == 0:
			active_index = slots.size() - 1
		else:
			active_index -= 1
	
	if Input.is_action_just_pressed("scroll_up"):
		if active_index == slots.size() - 1:
			active_index = 0
		else:
			active_index += 1

func get_active_slot() -> InventorySlot:
	return slots[active_index]
