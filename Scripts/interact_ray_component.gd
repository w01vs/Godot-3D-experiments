class_name InteractRayComponent extends Component

var current_collider: Object
@export var ray: RayCast3D
	
func _physics_process(_delta: float) -> void:
	var collider: Object = ray.get_collider()
	if ray.is_colliding() and collider is ComponentArea3D:
		if current_collider != collider:
			current_collider = collider	
		if(Input.is_action_just_pressed("interact")):
			collider.hit.emit(entity)
	elif current_collider:
		current_collider = null

func set_mask(layer: int, on: bool) -> void:
	ray.set_collision_mask_value(layer, on)

func clear_mask() -> void:
	ray.collision_mask = 0
