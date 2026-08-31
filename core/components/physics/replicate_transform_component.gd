class_name ReplicateTransformComponent extends Component

@export var transform: Node3D

func _init_component() -> void:
	if transform == entity:
		queue_free()

func _physics_process(_delta: float) -> void:
	entity.global_transform = transform.global_transform
	transform.transform = Transform3D.IDENTITY
