class_name InventoryUI extends Control

@export var player_panel: InventoryPanel
@export var static_panel: InventoryPanel

func _ready() -> void:
	EventBus.subscribe(PlayerInventoryLoadedEvent, initialise)
	EventBus.subscribe(InventoryOpenUIEvent, _open_inventory)
	EventBus.subscribe(InventoryCloseUIEvent, _close_inventory)
	hide()
	player_panel.hide()
	static_panel.hide()
	
func initialise(event: PlayerInventoryLoadedEvent) -> void:
	player_panel.set_slot_count(event.data.size)
	player_panel.bind(event.bindings)
	player_panel.update_visuals(event.data.data, true)

func _open_inventory(event: InventoryOpenUIEvent) -> void:
	show()
	if event.static_inventory:
		static_panel.set_slot_count(event.static_inventory.size)
		static_panel.bind(event.bindings)
		static_panel.update_visuals(event.static_inventory.data, true)
		static_panel.show()
	player_panel.show()

func _close_inventory(_event: InventoryCloseUIEvent) -> void:
	static_panel.unbind()
	hide()
	player_panel.hide()
	static_panel.hide()
