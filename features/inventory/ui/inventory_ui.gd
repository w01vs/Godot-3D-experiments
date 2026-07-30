class_name InventoryUI extends PanelContainer

@export var grid: GridContainer

var slots: Array[InventorySlot]
enum UIState{ INVENTORY_OPEN, DEFAULT }
var ui_state: UIState = UIState.DEFAULT
const INVENTORY_SLOT = preload("uid://c3bf1h0lfalix")

func _ready() -> void:
	EventBus.subscribe(PlayerLoadedEvent, initialise)

	
func initialise(_event: PlayerLoadedEvent) -> void:
	#GlobalRefs.player.inventory.inventory_changed.connect(update_slot)
	#slots.resize(GlobalRefs.player.inventory.INVENTORY_SIZE)
	#for i in range(slots.size()):
		#slots[i] = INVENTORY_SLOT.instantiate()
		#slots[i].target = "inventory"
		#slots[i].index = i
		#grid.add_child(slots[i])
	#display_inventory(GlobalRefs.player.inventory.slots)
	pass

#func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("inventory"):
		#match ui_state:
			#UIState.DEFAULT:
				#_open_inventory()
			#UIState.INVENTORY_OPEN:
				#_close_inventory()

func update_visuals(data: Dictionary[int, InventoryUISlotData]) -> void:
	for i: int in data.keys():
		slots[i].set_data(data[i])

func _open_inventory() -> void:
	ui_state = UIState.INVENTORY_OPEN
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _close_inventory() -> void:
	ui_state = UIState.DEFAULT
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
