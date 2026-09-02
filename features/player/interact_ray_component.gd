class_name InteractRayComponent extends Component

@export var ray: CRayCast3D
var current_collider: Node3D

func _init_component() -> void:
	entity.subscribe(self, RayCastEntityEvent, _on_raycast_hit)
	InputManager.subscribe(InteractInputEvent, _interact)

func _on_raycast_hit(event: RayCastEntityEvent) -> void:
	if event.collider is CollisionObject3D:
		_send_interaction(true)
		current_collider = event.collider

func _interact(_event: InteractInputEvent) -> void:
	_send_interaction(false)

func _send_interaction(hover: bool) -> void:
	if current_collider and current_collider == ray.current_collider:
		if current_collider.get_collision_layer_value(2):
			if current_collider.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT):
				current_collider.hit(InteractionData.new(entity, hover))

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	ray.cset_collision_mask_value(CollisionLayer.INTERACTABLE, true)
	ray.set_area_collision(true)
	ray.set_body_collision(true)
