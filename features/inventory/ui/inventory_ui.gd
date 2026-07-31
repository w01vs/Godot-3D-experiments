class_name InventoryUI extends Control

@export var player_panel: InventoryPanel
@export var static_panel: InventoryPanel



func _ready() -> void:
	EventBus.subscribe(PlayerInventoryLoadedEvent, initialise)
	EventBus.subscribe(InventoryOpenUIEvent, _open_inventory)
	EventBus.subscribe(InventoryCloseUIEvent, _close_inventory)
	player_panel.hide()
	static_panel.hide()
	
func initialise(event: PlayerInventoryLoadedEvent) -> void:
	player_panel.bind(event.bindings)
	player_panel.set_slot_count(event.data.size)
	player_panel.update_visuals(event.data.data, true)

func _open_inventory(event: InventoryOpenUIEvent) -> void:
	if event.static_inventory:
		static_panel.bind(event.bindings)
		static_panel.set_slot_count(event.static_inventory.size)
		static_panel.update_visuals(event.static_inventory.data, true)
		static_panel.show()
	player_panel.show()
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _close_inventory(_event: InventoryCloseUIEvent) -> void:
	static_panel.unbind()
	hide()
	player_panel.hide()
	static_panel.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
