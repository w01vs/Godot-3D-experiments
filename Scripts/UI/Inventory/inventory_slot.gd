class_name InventorySlot extends PanelContainer

@onready var _img: TextureRect = $MarginContainer/TextureRect
@onready var _quantity_label: Label = $QuantityLabel

var slot_data: SlotData


func set_data(data: SlotData) -> void:
	slot_data = data


func update_ui() -> void:
	_img.texture = slot_data.item_data.texture
	_quantity_label.text = str(slot_data.quantity)
