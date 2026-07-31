class_name InventoryComponent extends Component

@export var inventory_size: int = 12
var HOTBAR_SIZE: int = 4

var inventory: Array[InventorySlotData]

static var mouse_data: InventorySlotData
var last_index: int

var bindings: InventoryBindings

signal inventory_updated(data: InventoryData)

func _init_component() -> void:
	entity.subscribe_local(InventoryOpenEntityEvent, _on_open)
	entity.subscribe_local(InventoryCloseEntityEvent, _on_close)
	bindings = InventoryBindings.new(grab_drop, inventory_updated)
	inventory.resize(inventory_size)

func _on_open(event: InventoryOpenEntityEvent) -> void:
	if event.is_player:
		entity.raise_global(InventoryOpenUIEvent.new(self, bindings))
	else:
		entity.raise_global(InventoryOpenUIEvent.new(self, bindings, _get_data()))

func _on_close(_event: InventoryCloseEntityEvent) -> void:
	entity.raise_global(InventoryCloseUIEvent.new(self))

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	if entity.has_component(PlayerComponent):
		var inv_save: InventorySave = preload("uid://b5oqc4fvtmllc")
		inventory.resize(inventory_size)
		if inv_save.main_inventory.size() != inventory_size:
			push_warning("Inventory data does not match inventory size. Crashes might occur.")
		for i in range(inv_save.main_inventory.size()):
			set_slot_data(i, inv_save.main_inventory[i])
		entity.raise_global(PlayerInventoryLoadedEvent.new(self, _get_data(), bindings))

#hotbar stuff, seperate component
#func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("scroll_down"):
		#if active_index == HOTBAR_SIZE - 1:
			#active_index = 0
		#else:
			#active_index += 1
		##hotbar active changed event
		#_set_active_item()
	#
	#if Input.is_action_just_pressed("scroll_up"):
		#if active_index == 0:
			#active_index = HOTBAR_SIZE - 1
		#else:
			#active_index -= 1
		#_set_active_item()
#
#func _set_active_item() -> void:
	##hotbar active changed event
	#player.switch_hotbar_slot(active_index)
#
#func load_active_item() -> void:
	#if hotbar_slots[active_index]:
		#player.hotbar_load_item(hotbar_slots[active_index].item_data.model.instantiate(), active_index, hotbar_slots[active_index].item_data)
	#else:
		#player.hotbar_load_item(null, active_index, hotbar_slots[active_index].item_data)

# inventory stuff
func set_slot_data(index: int, data: InventorySlotData) -> void:
	inventory[index] = data
	var inv_data: InventoryData = InventoryData.new({index: _to_ui_data(data)}, inventory_size)
	inventory_updated.emit(inv_data)
	#if data:
		#load_active_item()

func grab_drop(index: int) -> void:
	var current_array: Array[InventorySlotData] = inventory
	var target_data: InventorySlotData = current_array[index]
	if mouse_data:
		if target_data == null:
			set_slot_data(index, mouse_data)
			set_mouse_data(null)
		elif target_data.item_data == mouse_data.item_data and target_data.item_data.stackable:
			var leftover: int = _execute_merge(index, mouse_data.quantity)
			if leftover > 0:
				mouse_data.quantity = leftover
				set_mouse_data(mouse_data)
			else:
				set_mouse_data(null)
		else:
			var temp: InventorySlotData = target_data
			set_slot_data(index, mouse_data)
			set_mouse_data(temp)
	else:
		if target_data != null:
			set_mouse_data(target_data)
			set_slot_data(index, null)

func _execute_merge(index: int, incoming_qty: int) -> int:
	var current_array: Array[InventorySlotData] = inventory
	var slot: InventorySlotData = current_array[index]
	var max_stack: int = slot.item_data.max_quantity
	var space_left: int = max_stack - slot.quantity
	var amount_to_take: int = min(incoming_qty, space_left)
	slot.quantity += amount_to_take
	set_slot_data(index, slot) 
	return incoming_qty - amount_to_take

func set_mouse_data(data: InventorySlotData) -> void:
	mouse_data = data
	entity.raise_global(DragPreviewChangedEvent.new(self, _to_ui_data(data)))

func add_item(itemdata: ItemData, amount: int) -> bool:
	for index in range(inventory_size):
		if inventory[index] == null:
			push_warning("Not taking into account item stack limits or full inventories etc.")
			inventory[index] = InventorySlotData.new()
			inventory[index].item_data = itemdata
			inventory[index].quantity = amount
			set_slot_data(index, inventory[index])
			return true
	return false

func _get_data() -> InventoryData:
	var dict: Dictionary[int, InventoryUISlotData] = {}
	for i in range(inventory.size()):
		if inventory[i]:
			dict.set(i, _to_ui_data(inventory[i]))
	var data: InventoryData = InventoryData.new(dict, inventory_size)
	return data

func _to_ui_data(inv_data: InventorySlotData) -> InventoryUISlotData:
	if inv_data and inv_data.item_data:
		var item_data: ItemData = inv_data.item_data
		return InventoryUISlotData.new(item_data.name, item_data.description, item_data.stackable, inv_data.quantity, item_data.icon)
	return null
