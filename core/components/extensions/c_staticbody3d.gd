class_name CStaticBody3D extends StaticBody3D

@export var entity: Entity
@export var target_component: String

func _ready() -> void:
	assert(entity != null)
	entity.raise_local(CollisionShapeRegisteredEntityEvent.new(self, target_component))
