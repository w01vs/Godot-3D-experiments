class_name ComponentArea3D extends Area3D

signal hit(entity: Entity)

@export var entity: Entity

func _ready() -> void:
	assert(entity != null)
