class_name InventorySlot extends PanelContainer

@onready var _img: TextureRect = $Button/MarginContainer/TextureRect
@onready var _quantity_label: Label = $QuantityLabel

var slot_data: SlotData

func set_data(data: SlotData) -> void:
	slot_data = data

func update_ui() -> void:
	if slot_data and slot_data.item_data:
		_img.texture = slot_data.item_data.texture
		if slot_data.item_data.stackable:
			_quantity_label.text = str(slot_data.quantity)
	else:
		_img.texture = null
		_quantity_label.text = ""
	_img.visible = true
	_quantity_label.visible = true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_interaction()

func handle_interaction() -> void:
	if GlobalRefs.drag_preview.is_dragging:
		var mouse_data: SlotData = GlobalRefs.drag_preview.drop_data()
		if slot_data == null:
			slot_data = mouse_data
			GlobalRefs.drag_preview.grab_data(null)
		elif slot_data.item_data == mouse_data.item_data and slot_data.item_data.stackable:
			var leftover: int = merge_data(mouse_data)
			if leftover > 0:
				mouse_data.quantity = leftover
				GlobalRefs.drag_preview.grab_data(mouse_data)
			else:
				GlobalRefs.drag_preview.grab_data(null)
		else:
			var to_mouse = slot_data
			slot_data = mouse_data
			GlobalRefs.drag_preview.grab_data(to_mouse)
	else:
		if slot_data != null:
			GlobalRefs.drag_preview.grab_data(slot_data)
			slot_data = null
	update_ui()

func merge_data(incoming_data: SlotData) -> int:
	if not slot_data or slot_data.item_data != incoming_data.item_data:
		return incoming_data.quantity
	if not slot_data.item_data.stackable:
		return incoming_data.quantity
	var max_stack: int = slot_data.item_data.max_quantity
	var space_left: int = max_stack - slot_data.quantity
	if space_left <= 0:
		return incoming_data.quantity
	var amount_to_take: int = min(incoming_data.quantity, space_left)
	slot_data.quantity += amount_to_take
	return incoming_data.quantity - amount_to_take
