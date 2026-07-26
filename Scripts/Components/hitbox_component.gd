class_name HitboxComponent extends Component

@export var _area: ComponentArea3D
 
var on_hit_information: OnHitInformation

func _init_component() -> void:
	_area.set_collision_layer_value(1, false)
	_area.set_collision_mask_value(1, false)
	_area.set_collision_layer_value(4, true)
	_area.set_collision_mask_value(3, true)
	_area.area_entered.connect(_on_area_entered)
	set_monitorable(false)
	set_monitoring(false)

func set_info(info: OnHitInformation) -> void:
	on_hit_information = info

func _on_area_entered(area: Area3D) -> void:
	assert(area is ComponentArea3D)
	if area is ComponentArea3D:
		area.hit.emit(entity)

func set_monitoring(on: bool) -> void:
	_area.monitoring = on

func set_monitorable(on: bool) -> void:
	_area.monitorable = on
