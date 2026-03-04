class_name ItemData extends Resource


@export_group("Item Info")
@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
# @@ show_if(stackable)
@export var max_quantity: int = 1
@export_group("UI")
@export var texture: AtlasTexture
