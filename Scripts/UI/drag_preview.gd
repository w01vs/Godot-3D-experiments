class_name DragPreview
extends TextureRect

var held_slot_data: SlotData = null
var is_dragging: bool = false

func _ready() -> void:
	GlobalRefs.drag_preview = self
	visible = false

func _process(_delta):
	global_position = get_global_mouse_position()
	if held_slot_data != null:
		global_position -= texture.get_size() / 1.5

func grab_data(data: SlotData) -> void:
	if data:
		held_slot_data = data.duplicate()
		is_dragging = true
		visible = true
		if held_slot_data and held_slot_data.item_data:
			texture = held_slot_data.item_data.texture
	else:
		held_slot_data = null

func drop_data() -> SlotData:
	var data_to_return = held_slot_data
	held_slot_data = null
	is_dragging = false
	visible = false
	return data_to_return
