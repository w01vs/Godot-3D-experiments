@abstract class_name ItemData extends Resource

@export_group("Item Info")
@export var name: String
@export var id: String
@export_multiline var description: String
@export var stackable: bool = false
@export var max_quantity: int = 1
@export var model: PackedScene
@export_group("UI")
@export var icon: Texture2D
@export_group("Animations")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Does this item have animations?") var has_animation: bool = false
@export var animation_type: StringName = AnimationType.CUSTOM
@export var animation_name: StringName
