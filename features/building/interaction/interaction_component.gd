@abstract class_name InteractionComponent extends Component

@export var collision_shape: CollisionObject3D


## Dont override this function!!
func _init_component() -> void:
	subscribe(CollisionOneshotEntityEvent, _interact)
	_config_collision_shape()

func _config_collision_shape() -> void:
	collision_shape.cset_collision_layer_value(CollisionLayer.INTERACTABLE, true)

@abstract func _interact(event: CollisionOneshotEntityEvent) -> void
