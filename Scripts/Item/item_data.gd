@abstract class_name ItemData extends Resource

enum AnimationType { WEAPON1H, TOOL1H, CUSTOM}

@export_group("Item Info")
@export var name: String
@export var id: String
@export_multiline var description: String
@export var stackable: bool = false
@export var max_quantity: int = 1
@export var model: PackedScene
@export_group("UI")
@export var texture: Texture2D
@export_group("Animations")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "Does this item have animations?") var has_animation: bool = false
@export var animation_type: AnimationType
@export var anim: StringName
