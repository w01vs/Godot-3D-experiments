class_name CArea3D extends Area3D

@export var entity: Entity
@export var target_component: String

func _ready() -> void:
	assert(entity != null)
	entity.raise_local(CollisionShapeRegisteredEntityEvent.new(self, target_component))
