class_name HotbarUI extends Control

@export var grid: GridContainer
const INVENTORY_SLOT = preload("uid://c3bf1h0lfalix")

var bindings: InventoryBindings

var slots: Array[InventorySlot]

func _ready() -> void:
	EventBus.subscribe(PlayerInventoryLoadedEvent, initialise)
	EventBus.subscribe(HotbarChangedEvent, _set_active_slot)

func initialise(event: PlayerInventoryLoadedEvent) -> void:
	set_slot_count(event.hotbar_data.size, event.data.size)
	display_hotbar(event.hotbar_data.data)
	bind(event.bindings)

func set_slot_count(slot_count: int, inventory_slot_count: int) -> void:
	if slot_count < slots.size():
		for i in range(slot_count, slots.size()):
			slots[i].hide()
	if slot_count > slots.size():
		slots.resize(slot_count)
		for i in range(slot_count):
			if !slots[i]:
				slots[i] = INVENTORY_SLOT.instantiate()
				slots[i].index = i + inventory_slot_count
				grid.add_child(slots[i])
			if !slots[i].visible:
				slots[i].show()

func bind(bindings_: InventoryBindings) -> void:
	bindings = bindings_
	for slot in slots:
		slot.bind(bindings)
	bindings.inventory_changed.connect(_update_hotbar)

func unbind() -> void:
	bindings = null
	for slot in slots:
		slot.unbind()
	bindings.inventory_changed.disconnect(_update_hotbar)

func _set_active_slot(event: HotbarChangedEvent) -> void:
	slots[event.old_index].toggle_border(false)
	slots[event.index].toggle_border(true)

func display_hotbar(data: Dictionary[int, InventoryUISlotData]) -> void:
		for i in range(slots.size()):
			if data.has(i):
				slots[i].set_data(data[i])

func _update_hotbar(data: InventoryData) -> void:
	if data.hotbar:
		display_hotbar(data.data)
