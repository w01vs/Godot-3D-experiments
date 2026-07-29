class_name InventorySlot extends PanelContainer

@onready var img: TextureRect = $Button/MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@onready var border: Panel = $Button/Panel

var slot_data: SlotData
var index: int
var target: String

func set_data(data: SlotData) -> void:
	slot_data = data
	update_ui()

func update_ui() -> void:
	if slot_data and slot_data.item_data:
		img.texture = slot_data.item_data.texture
		if slot_data.item_data.stackable:
			quantity_label.text = str(slot_data.quantity)
		else:
			quantity_label.text = ""
	else:
		img.texture = null
		quantity_label.text = ""
	img.visible = true
	quantity_label.visible = true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			GlobalRefs.player.inventory.handle_interaction(index, target)

func toggle_border(on: bool) -> void:
	border.visible = on
