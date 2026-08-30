class_name CRayCast3D extends RayCast3D

@export var entity: Entity
var current_collider: Object

func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		var collider: Object = get_collider()
		if is_colliding():
			if current_collider != collider:
				current_collider = collider
				entity.raise_local(RayCastEntityEvent.new(self, current_collider))
		elif current_collider:
			current_collider = null

func cset_collision_mask_value(value: int, on: bool) -> void:
	set_collision_mask_value(value, on)

func set_area_collision(on: bool) -> void:
	collide_with_areas = on

func set_body_collision(on: bool) -> void:
	collide_with_bodies = on
