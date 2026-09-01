class_name InventoryPanel extends PanelContainer

@export var grid: GridContainer

var slots: Array[InventorySlot]
const INVENTORY_SLOT = preload("uid://c3bf1h0lfalix")
var bindings: InventoryBindings

func set_slot_count(slot_count: int) -> void:
	if slot_count < slots.size():
		for i in range(slot_count, slots.size()):
			slots[i].hide()
	if slot_count > slots.size():
		slots.resize(slot_count)
		for i in range(slot_count):
			if !slots[i]:
				slots[i] = INVENTORY_SLOT.instantiate()
				slots[i].index = i
				grid.add_child(slots[i])
			if !slots[i].visible:
				slots[i].show()

func update_visuals(data: Dictionary[int, InventoryUISlotData], reset: bool = false) -> void:
	if reset:
		for i in range(slots.size()):
			if data.has(i):
				slots[i].set_data(data[i])
			else:
				slots[i].set_data(null)
	else:
		for i: int in data.keys():
			slots[i].set_data(data[i])

func _on_inventory_changed(data: InventoryData) -> void:
	if !data.hotbar:
		update_visuals(data.data)

func bind(bindings_: InventoryBindings) -> void:
	bindings = bindings_
	for slot in slots:
		slot.bind(bindings)
	bindings.inventory_changed.connect(_on_inventory_changed)

func unbind() -> void:
	if bindings:
		bindings.inventory_changed.disconnect(_on_inventory_changed)
		bindings = null
		for slot in slots:
			slot.unbind()
