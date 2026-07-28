class_name HitboxComponent extends Component

@export var _area: CArea3D
 
var damage_info: DamageInfo

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_area_set)

func _on_area_set(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CArea3D and event.target_components.has(script_name):
		_area.set_collision_mask_value(3, true)
		_area.area_entered.connect(_on_area_entered)

func set_info(info: DamageInfo) -> void:
	damage_info = info

func _on_area_entered(area: Area3D) -> void:
	assert(area is CArea3D)
	if area is CArea3D:
		area.hit.emit(HitData.new(entity, damage_info))

func set_monitoring(on: bool) -> void:
	_area.monitoring = on

func set_monitorable(on: bool) -> void:
	_area.monitorable = on

static func _get_tags() -> Set:
	var tags: Set = Set.new()
	tags.add(CArea3D)
	return tags
