class_name InventoryComponent extends Component

@export var inventory_size: int = 12
@export var hotbar_size: int = 4

var inventory: Array[ItemStack]
var hotbar: Array[ItemStack]

var active_index: int = 0

static var mouse_data: ItemStack
var last_index: int

var bindings: InventoryBindings

signal inventory_updated(data: InventoryData)
signal equipment_updated(index: int, data: ItemData, update: bool)

var open: bool = false

func _init_component() -> void:
	subscribe(InventoryOpenEntityEvent, _on_open)
	subscribe(InventoryCloseEntityEvent, _close)
	InputManager.subscribe(UICloseInputEvent, _close)
	bindings = InventoryBindings.new(grab_drop, inventory_updated, equipment_updated, _drop_item)
	subscribe(PlayerLoadedEvent, _on_player_load)
	inventory.resize(inventory_size)

func _drop_item(data: ItemStack) -> void:
	var drop: Entity = SceneLoader.get_scene_instance(mouse_data.item_data.dropped_model) as Entity
	if entity.has_component(PlayerComponent):
	# TODO: drop from player
		pass
	else:
	# TODO: drop from chest
		pass
	emit(DragPreviewChangedEvent.new(self, null))
	 

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
		emit(InventoryOpenUIEvent.new(self, bindings))
		ContextManager.push_player_state(PlayerContext.State.INVENTORY)
	else:
		emit(InventoryOpenUIEvent.new(self, bindings, _get_data()))
	InputManager.release_mouse()
	open = !open

func _on_open(event: InventoryOpenEntityEvent) -> void:
	_open(event.is_player)

func _close(_event: EventBase) -> void:
	if open:
		if mouse_data:
			add_item(mouse_data.item_data, mouse_data.quantity, true, false)
			emit(DragPreviewChangedEvent.new(self, null))
			
		emit(InventoryCloseUIEvent.new(self))
		ContextManager.pop_player_state()
		open = !open
		InputManager.capture_mouse()

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
		emit(PlayerInventoryLoadedEvent.new(self, _get_data(), bindings, _get_hotbar_data(), _get_hotbar_itemdata()))
		emit(HotbarActiveChangedEvent.new(self, 0, 0))

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
	emit(HotbarActiveChangedEvent.new(self, index, old_index))

func set_slot_data(index: int, data: ItemStack) -> void:
	_set_index(index, data)

func grab_drop(index: int) -> void:
	var target_data: ItemStack = _get_index(index)
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
			var temp: ItemStack = target_data
			set_slot_data(index, mouse_data)
			set_mouse_data(temp)
	else:
		if target_data != null:
			set_mouse_data(target_data)
			set_slot_data(index, null)

func _get_index(index: int) -> ItemStack:
	if index >= inventory_size:
		return hotbar[index-inventory_size]
	return inventory[index]

func _set_index(index: int, data: ItemStack) -> void:
	if index >= inventory_size:
		hotbar[index-inventory_size] = data
		if data:
			equipment_updated.emit(index-inventory_size, data.item_data, active_index == index-inventory_size)
		else:
			equipment_updated.emit(index-inventory_size, null, active_index == index-inventory_size)
	else:
		inventory[index] = data
	var inv_data: InventoryData = _to_inventory_data(index, data)
	inventory_updated.emit(inv_data)

func _add_quantity(index: int, quantity: int) -> void:
	assert(quantity >= 0)
	var inv_data: InventoryData
	if index >= inventory_size:
		hotbar[index - inventory_size].quantity += quantity
		inv_data = _to_inventory_data(index, hotbar[index - inventory_size])
		# TODO: figure out what to do here....?
		#if data:
			#equipment_updated.emit(index-inventory_size, data.item_data, active_index == index-inventory_size)
		#else:
			#equipment_updated.emit(index-inventory_size, null, active_index == index-inventory_size)
	else:
		inventory[index].quantity += quantity
		inv_data = _to_inventory_data(index, inventory[index])
	inventory_updated.emit(inv_data)

func _execute_merge(index: int, incoming_qty: int, preview: bool = false) -> int:
	var slot: ItemStack = _get_index(index)
	var max_stack: int = slot.item_data.max_quantity
	var space_left: int = max_stack - slot.quantity
	var amount_to_take: int = min(incoming_qty, space_left)
	if !preview:
		set_slot_data(index, slot) 
		slot.quantity += amount_to_take
	return incoming_qty - amount_to_take

##   [code]has_item[/code] returns a [code]Dictionary[/code] with the following fields: [br]
##   [code]total[/code]: The quantity of the queried item in the inventory [br]
##   [code]indices[/code]: An [code]Array[Dictionary][/code] containing the indices at which this item is found,
##   in order of: hotbar (left to right) and then the inventory from top left to bottom right, going 
##   left to right in each row before moving down a column.[br]
## [br]     The elements of [code]indices[/code] are [code]Dictionaries[/code] with teh following fields:
## [br]     [code]index[/code]: The index at which this entry was found
## [br]     [code]quantity[/code]: The quantity of the item found at this index
func has_item(itemdata: ItemData) -> Dictionary:
	var indices: Array[Dictionary] = []
	var total: int = 0
	for i in range(hotbar_size):
		if hotbar[i] and hotbar[i].item_data and hotbar[i].item_data == itemdata:
			indices.append({ &"index": i + inventory_size, &"quantity": hotbar[i].quantity })
			total += hotbar[i].quantity
	for i in range(inventory_size):
		if inventory[i] and inventory[i].item_data and inventory[i].item_data == itemdata:
			indices.append({ &"index": i, &"quantity": inventory[i].quantity })
			total += inventory[i].quantity
	return { &"indices": indices, &"total": total }

func set_mouse_data(data: ItemStack) -> void:
	mouse_data = data
	emit(DragPreviewChangedEvent.new(self, _to_ui_data(data)))

func add_item(itemdata: ItemData, amount: int, partial_add: bool = true, drop_excess: bool = false) -> int:
	var total: int = amount
	var info: Dictionary = has_item(itemdata)
	# In case a partial add is not allowed, the quantites stored in this array are not applied to the inventory
	var actions: Dictionary[int, Dictionary] = {}
	if info.total != 0 and itemdata.stackable:
		for indice: Dictionary in info.indices:
			var i: int = indice.index
			var leftover: int = _execute_merge(i, total, true)
			actions[i] = { &"quantity": total - leftover, &"merge": true}
			total = leftover
			if total == 0:
				break
	if total > 0:
		var i: int = 0
		var index: int = 0
		while i < inventory_size + hotbar_size:
			if i < hotbar_size:
				index = i + inventory_size
			else:
				index = i - hotbar_size
			if !_get_index(index):
				var leftover: int = total - min(itemdata.max_quantity, total)
				actions[index] = { &"quantity": total - leftover, &"merge": false}
				total = leftover
				if total <= 0:
					break
			i += 1
	if total <= 0 or (partial_add and total > 0):
		for i in actions.keys():
			var action: Dictionary = actions[i]
			if action.merge:
				_add_quantity(i, action.quantity)
			else:
				var data := ItemStack.new()
				data.item_data = itemdata
				data.quantity = action.quantity
				_set_index(i, data)
	if total > 0 and drop_excess:
		_drop_item(ItemStack.new(itemdata, total))
	return total

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

func _to_inventory_data(index: int, data: ItemStack) -> InventoryData:
	if index >= inventory_size:
		index -= inventory_size
		return InventoryData.new({index: _to_ui_data(data)}, hotbar_size, true)
	return InventoryData.new({index: _to_ui_data(data)}, inventory_size)

func _to_ui_data(inv_data: ItemStack) -> InventoryUISlotData:
	if inv_data and inv_data.item_data:
		var item_data: ItemData = inv_data.item_data
		return InventoryUISlotData.new(item_data.name, item_data.description, item_data.stackable, inv_data.quantity, item_data.icon)
	return null
