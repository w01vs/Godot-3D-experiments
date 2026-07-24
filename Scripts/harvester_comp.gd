class_name HarvesterComponent extends Node

@export var root: Item

func _ready() -> void:
	root.set_meta(ComponentType.HARVESTER, self)
