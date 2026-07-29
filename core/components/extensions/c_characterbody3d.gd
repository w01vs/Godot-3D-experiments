class_name CCharacterBody3D extends CharacterBody3D

@export var entity: Entity

func _ready() -> void:
	entity.raise_local(CollisionShapeRegisteredEntityEvent.new(self))
