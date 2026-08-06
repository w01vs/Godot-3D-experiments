class_name InventoryComponent extends Component

@export var inventory_size: int = 12
@export var hotbar_size: int = 4

var inventory: Array[InventorySlotData]
var hotbar: Array[InventorySlotData]

var active_index: int = 0

static var mouse_data: InventorySlotData
var last_index: int

var bindings: InventoryBindings

signal inventory_updated(data: InventoryData)
signal equipment_updated(index: int, data: ItemData)

var open: bool = false

func _init_component() -> void:
	entity.subscribe_local(InventoryOpenEntityEvent, _on_open)
	entity.subscribe_local(InventoryCloseEntityEvent, _close)
	InputManager.subscribe(UICloseInputEvent, _close)
	bindings = InventoryBindings.new(grab_drop, inventory_updated, equipment_updated)
	entity.subscribe_global(PlayerLoadedEvent, _on_player_load)
	inventory.resize(inventory_size)

func _on_player_load(_event: PlayerLoadedEvent) -> void:
	if entity.has_component(PlayerComponent):
		InputManager.subscribe(NextHotbarInputEvent, _next_hotbar)
		InputManager.subscribe(InventoryInputEvent, _on_player_inventory)
		InputManager.subscribe(PreviousHotbarInputEvent, _previous_hotbar)

# Player exclusive
func _on_player_inventory(_event: InventoryInputEvent) -> void:
	if open:
		_close(null)
	else:
		_open(true)

func _open(player: bool) -> void:
	if player:
		entity.raise_global(InventoryOpenUIEvent.new(self, bindings))
		ContextManager.push_player_state(PlayerContext.State.INVENTORY)
	else:
		entity.raise_global(InventoryOpenUIEvent.new(self, bindings, _get_data()))
	open = !open

func _on_open(event: InventoryOpenEntityEvent) -> void:
	_open(event.is_player)

func _close(_event: CustomInputEvent) -> void:
	if open:
		entity.raise_global(InventoryCloseUIEvent.new(self))
		ContextManager.pop_player_state()
		open = !open

# Player exclusive
func _on_entity_load(_event: EntityLoadedEvent) -> void:
	if entity.has_component(PlayerComponent):
		var inv_save: InventorySave = preload("uid://b5oqc4fvtmllc")
		inventory.resize(inventory_size)
		hotbar.resize(hotbar_size)
		if inv_save.main_inventory.size() != inventory_size:
			push_warning("Inventory data does not match inventory size. Crashes might occur.")
		for i in range(inv_save.main_inventory.size()):
			set_slot_data(i, inv_save.main_inventory[i])
		entity.raise_global(PlayerInventoryLoadedEvent.new(self, _get_data(), bindings, _get_hotbar_data(), _get_hotbar_itemdata()))
		entity.raise_global(HotbarChangedEvent.new(self, 0, 0))

func is_open() -> bool:
	return open

# Player exclusive
func _next_hotbar(_event: NextHotbarInputEvent) -> void:
	var old: int = active_index
	if active_index == hotbar_size - 1:
		active_index = 0
	else:
		active_index += 1
	_set_active_item(active_index, old)

# Player exclusive
func _previous_hotbar(_event: PreviousHotbarInputEvent) -> void:
	var old: int = active_index
	if active_index == 0:
		active_index = hotbar_size - 1
	else:
		active_index -= 1
	_set_active_item(active_index, old)

# Player exclusive
func _set_active_item(index: int, old_index: int) -> void:
	entity.raise_global(HotbarChangedEvent.new(self, index, old_index))

func set_slot_data(index: int, data: InventorySlotData) -> void:
	_set_index(index, data)

func grab_drop(index: int) -> void:
	var target_data: InventorySlotData = _get_index(index)
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

func _get_index(index: int) -> InventorySlotData:
	if index >= inventory_size:
		return hotbar[index-inventory_size]
	return inventory[index]

func _set_index(index: int, data: InventorySlotData) -> void:
	if index >= inventory_size:
		hotbar[index-inventory_size] = data
		if data:
			equipment_updated.emit(index-inventory_size, data.item_data)
		else:
			equipment_updated.emit(index-inventory_size, null)
		if index-inventory_size == active_index:
			entity.raise_global(HotbarChangedEvent.new(self, active_index, active_index))
	else:
		inventory[index] = data
	var inv_data: InventoryData = _to_inventory_data(index, data)
	inventory_updated.emit(inv_data)

func _execute_merge(index: int, incoming_qty: int) -> int:
	var slot: InventorySlotData = _get_index(index)
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

func _get_hotbar_data() -> InventoryData:
	var dict: Dictionary[int, InventoryUISlotData] = {}
	for i in range(hotbar.size()):
		if hotbar[i]:
			dict.set(i, _to_ui_data(hotbar[i]))
	var data: InventoryData = InventoryData.new(dict, hotbar_size, true)
	return data

func _get_hotbar_itemdata() -> Array[ItemData]:
	var arr: Array[ItemData]
	for item in hotbar:
		if item:
			arr.append(item.item_data)
	return arr

func _to_inventory_data(index: int, data: InventorySlotData) -> InventoryData:
	if index >= inventory_size:
		index -= inventory_size
		return InventoryData.new({index: _to_ui_data(data)}, hotbar_size, true)
	return InventoryData.new({index: _to_ui_data(data)}, inventory_size)

func _to_ui_data(inv_data: InventorySlotData) -> InventoryUISlotData:
	if inv_data and inv_data.item_data:
		var item_data: ItemData = inv_data.item_data
		return InventoryUISlotData.new(item_data.name, item_data.description, item_data.stackable, inv_data.quantity, item_data.icon)
	return null
