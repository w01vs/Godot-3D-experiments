class_name HitboxComponent extends Component

@export var _area: Area3D
 
var on_hit_information: OnHitInformation

func _init_component() -> void:
	type = ComponentType.HITBOX
	register(_area)
	_area.set_collision_layer_value(1, false)
	_area.set_collision_mask_value(1, false)
	_area.set_collision_layer_value(4, true)
	_area.set_collision_mask_value(3, true)
	_area.connect("area_entered", _on_area_entered)

func set_info(info: OnHitInformation) -> void:
	on_hit_information = info

func _on_area_entered(area: Area3D):
	if area.has_meta(ComponentType.HURTBOX):
		area.get_meta(ComponentType.HURTBOX).hit(self)

func set_monitoring(on: bool) -> void:
	_area.monitoring = on

func set_monitorable(on: bool) -> void:
	_area.monitorable = on
