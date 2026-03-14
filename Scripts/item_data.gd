class_name ItemData extends Resource


@export_group("Item Info")
@export var name: String
@export var id: String
@export_multiline var description: String
@export var stackable: bool = false
@export var max_quantity: int = 1
@export var model: PackedScene
@export_group("UI")
@export var texture: Texture2D
