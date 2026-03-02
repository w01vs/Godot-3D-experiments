class_name InventorySlot extends PanelContainer

@onready var _img: TextureRect = $Button/MarginContainer/TextureRect
@onready var _quantity_label: Label = $QuantityLabel

var slot_data: SlotData

func set_data(data: SlotData) -> void:
	slot_data = data

func update_ui() -> void:
	if slot_data:
		_img.texture = slot_data.item_data.texture
		if slot_data.item_data.stackable:
			_quantity_label.text = str(slot_data.quantity)
	else:
		_img.texture = null
		_quantity_label.text = ""
	_img.visible = true
	_quantity_label.visible = true

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot

func _get_drag_data(at_position: Vector2) -> Variant:
	var data = slot_data
	if data == null:
		return null
	var preview: TextureRect = TextureRect.new()
	preview.texture = _img.texture
	set_drag_preview(preview)
	_img.visible = false
	_quantity_label.visible = false
	return self

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp_data = slot_data
	slot_data = data.slot_data
	data.slot_data = temp_data
	
	update_ui()
	data.update_ui()
	
func _notification(what: int) -> void:
	if !is_inside_tree():
		return
	if what == NOTIFICATION_DRAG_END:
		if not get_viewport().gui_is_drag_successful():
			_on_drag_cancelled()

func _on_drag_cancelled():
	print("The item was dropped into the void!")
	update_ui()
