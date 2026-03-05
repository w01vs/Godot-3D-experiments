class_name InventoryUI extends PanelContainer

@onready var grid: GridContainer = $MarginContainer/ItemGrid

var slots: Array[InventorySlot]
enum UIState{ INVENTORY_OPEN, DEFAULT }
var ui_state: UIState = UIState.DEFAULT

var slot: PackedScene = preload("res://Scenes/Inventory/inventory_slot.tscn")

func _ready() -> void:
	if GlobalRefs.player:
		initialise()
	else:
		GlobalRefs.player_set.connect(initialise)
	
func initialise() -> void:
	GlobalRefs.player.inventory.inventory_changed.connect(update_slot)
	slots.resize(GlobalRefs.player.inventory.INVENTORY_SIZE)
	for i in range(slots.size()):
		slots[i] = slot.instantiate()
		grid.add_child(slots[i])
	display_inventory(GlobalRefs.player.inventory.slots)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		match ui_state:
			UIState.DEFAULT:
				_open_inventory()
			UIState.INVENTORY_OPEN:
				_close_inventory()

func update_slot(index: int, data: SlotData) -> void:
	slots[index].set_data(data)

func display_inventory(data: Array[SlotData]) -> void:
	for i in range(data.size()):
		slots[i].set_data(data[i])

func _open_inventory() -> void:
	ui_state = UIState.INVENTORY_OPEN
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _close_inventory() -> void:
	ui_state = UIState.DEFAULT
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
