class_name Inventory extends Node

signal inventory_changed(index: int, data: SlotData, target: String)
signal hotbar_active_changed(index: int)

var INVENTORY_SIZE: int = 12
var HOTBAR_SIZE: int = 4

var slots: Array[SlotData] = []
var hotbar_slots: Array[SlotData] = []
var mouse_data: SlotData

var active_index: int

@onready var player: Player = $".."

func _ready() -> void:
	var inv_data = preload("res://Resources/Inventory/inventory_data.tres")
	slots.resize(INVENTORY_SIZE)
	hotbar_slots.resize(HOTBAR_SIZE)
	if inv_data.main_inventory.size() != INVENTORY_SIZE:
		push_warning("Inventory data does not match inventory size. Crashes might occur.")
	if inv_data.hotbar.size() != HOTBAR_SIZE:
		push_warning("Hotbar data does not match hotbar size. Crashes might occur.")
	for i in range(inv_data.main_inventory.size()):
		set_slot_data(i, inv_data.main_inventory[i], "inventory")
	for i in range(inv_data.hotbar.size()):
		set_slot_data(i, inv_data.hotbar[i], "hotbar")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("scroll_down"):
		if active_index == 0:
			active_index = HOTBAR_SIZE - 1
		else:
			active_index -= 1
		hotbar_active_changed.emit(active_index)
		_set_active_item()
	
	if Input.is_action_just_pressed("scroll_up"):
		if active_index == HOTBAR_SIZE - 1:
			active_index = 0
		else:
			active_index += 1
		hotbar_active_changed.emit(active_index)
		_set_active_item()

func _set_active_item() -> void:
	player.switch_hotbar_slot(active_index)

func _load_active_item() -> void:
	if hotbar_slots[active_index]:
		player.hotbar_load_item(hotbar_slots[active_index].item_data.model.instantiate(), active_index)
	else:
		player.hotbar_load_item(null, active_index)

func set_slot_data(index: int, data: SlotData, target: String) -> void:
	match target:
		"inventory":
			slots[index] = data
		"hotbar":
			hotbar_slots[index] = data
			if data:
				_load_active_item()
	inventory_changed.emit(index, data, target)

func handle_interaction(index: int, target: String) -> void:
	var current_array = slots if target == "inventory" else hotbar_slots
	var target_data = current_array[index]
	if mouse_data:
		if target_data == null:
			set_slot_data(index, mouse_data, target)
			set_mouse_data(null)
		elif target_data.item_data == mouse_data.item_data and target_data.item_data.stackable:
			var leftover = _execute_merge(index, mouse_data.quantity, target)
			if leftover > 0:
				mouse_data.quantity = leftover
				set_mouse_data(mouse_data)
			else:
				set_mouse_data(null)
		else:
			var temp = target_data
			set_slot_data(index, mouse_data, target)
			set_mouse_data(temp)
	else:
		if target_data != null:
			set_mouse_data(target_data)
			set_slot_data(index, null, target)

func _execute_merge(index: int, incoming_qty: int, target: String) -> int:
	var current_array = slots if target == "inventory" else hotbar_slots
	var slot = current_array[index]
	var max_stack = slot.item_data.max_quantity
	var space_left = max_stack - slot.quantity
	var amount_to_take = min(incoming_qty, space_left)
	slot.quantity += amount_to_take
	set_slot_data(index, slot, target) 
	return incoming_qty - amount_to_take

func set_mouse_data(data: SlotData) -> void:
	mouse_data = data
	GlobalRefs.drag_preview.set_data(mouse_data)
