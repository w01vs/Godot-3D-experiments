class_name InventoryUISlotData extends RefCounted

var icon: Texture2D
var name: StringName
var quantity: int
var description: StringName
var stackable: bool

func _init(name_: StringName, description_: StringName, stackable_: bool, quantity_: int, icon_: Texture2D) -> void:
	name = name_
	description = description_
	stackable = stackable_
	quantity = quantity_
	icon = icon_
