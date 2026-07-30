class_name Inventory extends Node

var INVENTORY_SIZE: int = 12
var HOTBAR_SIZE: int = 4

var slots: Array[InventorySlotData] = []
var hotbar_slots: Array[InventorySlotData] = []
var mouse_data: InventorySlotData

var active_index: int = 0

@export var player: Player

func _ready() -> void:
	var inv_data: InventoryData = preload("res://features/inventory/data/inventory_data.tres")
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
	active_index = 0
	EventBus.subscribe(PlayerLoadedEvent, _on_player_loaded)
	EventBus.subscribe(InventoryOpenUIEvent, _on_open)
	EventBus.subscribe(InventoryCloseUIEvent, _on_close)

func _on_open(event: InventoryOpenUIEvent) -> void:
	pass

func _on_close(event: InventoryCloseUIEvent) -> void:
	pass

func _on_player_loaded(_event: PlayerLoadedEvent) -> void:
	_set_active_item()

#hotbar stuff, seperate component
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("scroll_down"):
		if active_index == HOTBAR_SIZE - 1:
			active_index = 0
		else:
			active_index += 1
		#hotbar active changed event
		_set_active_item()
	
	if Input.is_action_just_pressed("scroll_up"):
		if active_index == 0:
			active_index = HOTBAR_SIZE - 1
		else:
			active_index -= 1
		_set_active_item()

func _set_active_item() -> void:
	#hotbar active changed event
	player.switch_hotbar_slot(active_index)

func load_active_item() -> void:
	if hotbar_slots[active_index]:
		player.hotbar_load_item(hotbar_slots[active_index].item_data.model.instantiate(), active_index, hotbar_slots[active_index].item_data)
	else:
		player.hotbar_load_item(null, active_index, hotbar_slots[active_index].item_data)

# inventory stuff
func set_slot_data(index: int, data: InventorySlotData, target: String) -> void:
	match target:
		"inventory":
			slots[index] = data
		"hotbar":
			hotbar_slots[index] = data
			if data:
				load_active_item()
				# event that inventory was changed

func handle_interaction(index: int, target: String) -> void:
	var current_array: Array[InventorySlotData] = slots if target == "inventory" else hotbar_slots
	var target_data: InventorySlotData = current_array[index]
	if mouse_data:
		if target_data == null:
			set_slot_data(index, mouse_data, target)
			set_mouse_data(null)
		elif target_data.item_data == mouse_data.item_data and target_data.item_data.stackable:
			var leftover: int = _execute_merge(index, mouse_data.quantity, target)
			if leftover > 0:
				mouse_data.quantity = leftover
				set_mouse_data(mouse_data)
			else:
				set_mouse_data(null)
		else:
			var temp: InventorySlotData = target_data
			set_slot_data(index, mouse_data, target)
			set_mouse_data(temp)
	else:
		if target_data != null:
			set_mouse_data(target_data)
			set_slot_data(index, null, target)

func _execute_merge(index: int, incoming_qty: int, target: String) -> int:
	var current_array: Array[InventorySlotData] = slots if target == "inventory" else hotbar_slots
	var slot: InventorySlotData = current_array[index]
	var max_stack: int = slot.item_data.max_quantity
	var space_left: int = max_stack - slot.quantity
	var amount_to_take: int = min(incoming_qty, space_left)
	slot.quantity += amount_to_take
	set_slot_data(index, slot, target) 
	return incoming_qty - amount_to_take

func set_mouse_data(data: InventorySlotData) -> void:
	mouse_data = data
	#Set drag preview data

func add_item(itemdata: ItemData, amount: int) -> bool:
	for index in range(INVENTORY_SIZE):
		if slots[index] == null:
			push_warning("Not taking into account item stack limits or full inventories etc.")
			slots[index] = InventorySlotData.new()
			slots[index].item_data = itemdata
			slots[index].quantity = amount
			set_slot_data(index, slots[index], "inventory")
			return true
	return false

func _to_ui_data(inv_data: InventorySlotData) -> InventoryUISlotData:
	if inv_data.item_data:
		var item_data: ItemData = inv_data.item_data
		return InventoryUISlotData.new(item_data.name, item_data.description, item_data.stackable, inv_data.quantity, item_data.icon)
	return null
