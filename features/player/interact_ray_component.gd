class_name InteractRayComponent extends Component

@export var ray: CRayCast3D
var collider: Object

func _init_component() -> void:
	subscribe(RayCastEntityEvent, _on_raycast_hit)
	InputManager.subscribe(InteractInputEvent, _interact)

func _on_raycast_hit(event: RayCastEntityEvent) -> void:
	if event.collider is CollisionObject3D:
		if event.collider.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT):
			event.collider.enter(InteractionData.new(entity))
			collider = event.collider
	elif !event.collider:
		collider.exit(InteractionData.new(entity))
		collider = null

func _interact(_event: InteractInputEvent) -> void:
	if collider:
		collider.oneshot(InteractionData.new(entity))

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	ray.cset_collision_mask_value(CollisionLayer.INTERACTABLE, true)
	ray.set_area_collision(true)
	ray.set_body_collision(true)
