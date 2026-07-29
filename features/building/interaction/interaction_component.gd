@abstract class_name InteractionComponent extends Component

var collision_shape: CollisionObject3D


## Dont override this function!!
func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_collision_shape_registered)
	entity.subscribe_local(CollisionEntityEvent, _interact)

## [method _on_area_registered] is required and fires when a collision object is registered.
##[br] Check if the collision object is targeting this type of component before assigning.
@abstract func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void

@abstract func _interact(event: CollisionEntityEvent) -> void
