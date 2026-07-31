class_name InteractRayComponent extends Component

@export var ray: CRayCast3D
var current_collider: CollisionObject3D

func _init_component() -> void:
	entity.subscribe_local(RayCastRegisteredEntityEvent, _on_raycast_registered)
	entity.subscribe_local(RayCastEntityEvent, _on_raycast_hit)
	InputManager.subscribe(InteractInputEvent, _interact)

func _on_raycast_hit(event: RayCastEntityEvent) -> void:
	if event.collider is CollisionObject3D:
		current_collider = event.collider
		_send_interaction(true)

func _interact(_event: InteractInputEvent) -> void:
	_send_interaction(false)

func _send_interaction(hover: bool) -> void:
	if current_collider:
		if current_collider.get_collision_layer_value(2):
			if current_collider.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT):
				current_collider.hit(InteractionData.new(entity, hover))

func _on_raycast_registered(event: RayCastRegisteredEntityEvent) -> void:
	if ray == event.source:
		ray.cset_collision_mask_value(CollisionLayer.INTERACTABLE, true)
		ray.set_area_collision(true)
		ray.set_body_collision(true)
