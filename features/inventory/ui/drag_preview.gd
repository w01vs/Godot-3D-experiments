class_name DragPreview
extends TextureRect

var held_slot_data: InventoryUISlotData = null
var is_dragging: bool = false

@export var quantity_label: Label

func _ready() -> void:
	GlobalRefs.drag_preview = self
	visible = false

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if held_slot_data != null:
		global_position -= texture.get_size() / 1.5

func set_data(data: InventoryUISlotData) -> void:
	if data:
		held_slot_data = data
		is_dragging = true
		visible = true
		if texture:
			texture = data.icon
			quantity_label.text = str(data.quantity)
	else:
		texture = null
		held_slot_data = null
		quantity_label.text = ""
