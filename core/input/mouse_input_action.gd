@tool
class_name MouseInputAction extends Resource

@export var name: StringName
@export var debug: bool = false:
	set(value):
		debug = value
		notify_property_list_changed()

@export var requirements: ContextQuery
@export var event: CustomInputEvent
@export var on_release: bool


func _validate_property(property: Dictionary) -> void:
	if property.name in ["player_requirements", "game_requirements", "event"]:
		if debug:
			property.usage = PROPERTY_USAGE_NO_EDITOR
