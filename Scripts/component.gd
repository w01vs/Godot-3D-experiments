@abstract class_name Component extends Node

@export var entity: Entity

func _ready() -> void:
	_init_component()
	assert(entity != null, "Component %s at %s requires an entity it is attached to." % [ name, get_path() ])
	entity.register(self)

func _init_component() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		entity.remove_component(self)
