class_name InteractableComponent extends Component

@export var body: CollisionObject3D = null

func _init_component() -> void:
	type = ComponentType.INTERACTABLE
	register(body)
	body.set_collision_layer_value(2, true)

func unregister() -> void:
	body.remove_meta(ComponentType.INTERACTABLE)

func interact(interacter: Node3D) -> void:
	get_parent().interact(interacter)
