class_name DragPreview
extends TextureRect

var held_slot_data: InventoryUISlotData = null
var is_dragging: bool = false

@export var quantity_label: Label

func _ready() -> void:
	visible = false
	EventBus.subscribe(DragPreviewChangedEvent, set_data)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	if held_slot_data != null:
		global_position -= texture.get_size() / 1.5

func set_data(event: DragPreviewChangedEvent) -> void:
	if event.data:
		held_slot_data = event.data
		is_dragging = true
		visible = true
		if event.data.icon:
			texture = event.data.icon
		if event.data.stackable:
			quantity_label.text = str(event.data.quantity)
	else:
		texture = null
		held_slot_data = null
		quantity_label.text = ""
