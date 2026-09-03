class_name CRayCast3D extends RayCast3D

@export var entity: Entity
var _current_collider: Object

func _ready() -> void:
	collision_mask = 0
	collide_with_areas = false
	collide_with_bodies = false

func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		var collider: Object = get_collider()
		if _current_collider != collider:
			_current_collider = collider
			entity.emit_local(RayCastEntityEvent.new(self, _current_collider))
		elif _current_collider:
			_current_collider = null

func get_current_collider() -> Object:
	return _current_collider

func cset_collision_mask_value(value: int, on: bool) -> void:
	set_collision_mask_value(value, on)

func set_area_collision(on: bool) -> void:
	collide_with_areas = on

func set_body_collision(on: bool) -> void:
	collide_with_bodies = on

func disable() -> void:
	enabled = false

func enable() -> void:
	enabled = true
