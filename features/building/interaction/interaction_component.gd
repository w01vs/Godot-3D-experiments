@abstract class_name InteractionComponent extends Component

@export var collision_shape: CollisionObject3D


## Dont override this function!!
func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_collision_shape_registered)
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _config_collision_shape)
	entity.subscribe_local(CollisionEntityEvent, _interact)

func _config_collision_shape(event: CollisionShapeRegisteredEntityEvent) -> void:
	if collision_shape == event.source:
		collision_shape = event.source as CollisionObject3D
		collision_shape.cset_collision_layer_value(CollisionLayer.INTERACTABLE, true)

## [method _on_area_registered] is required and fires when a collision object is registered.
@abstract func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void

@abstract func _interact(event: CollisionEntityEvent) -> void
