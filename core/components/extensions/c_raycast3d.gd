class_name CRayCast3D extends RayCast3D

@export var entity: Entity
@export var target_component: String

func _ready() -> void:
	entity.raise_local(RayCastRegisteredEntityEvent.new(self))
