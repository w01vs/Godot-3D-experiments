class_name InventorySlot extends PanelContainer

@onready var _img: TextureRect = $Button/MarginContainer/TextureRect
@onready var _quantity_label: Label = $QuantityLabel

var slot_data: SlotData
var index: int
var target: String

func set_data(data: SlotData) -> void:
	slot_data = data
	update_ui()

func update_ui() -> void:
	if slot_data and slot_data.item_data:
		_img.texture = slot_data.item_data.texture
		if slot_data.item_data.stackable:
			_quantity_label.text = str(slot_data.quantity)
		else:
			_quantity_label.text = ""
	else:
		_img.texture = null
		_quantity_label.text = ""
	_img.visible = true
	_quantity_label.visible = true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			GlobalRefs.player.inventory.handle_interaction(index, target)
