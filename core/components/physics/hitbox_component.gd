class_name HitboxComponent extends Component

@export var area_: CArea3D
 
var damage_info: DamageInfo

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_area_set)

func _on_area_set(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CArea3D and event.source.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT):
		area_.set_collision_mask_value(3, true)
		area_.area_entered.connect(_on_area_entered)

#func set_info(info: DamageInfo) -> void:
	#damage_info = info

func _on_area_entered(area: Area3D) -> void:
	assert(area is CArea3D)
	if area is CArea3D:
		area.hit(HitData.new(entity, damage_info))

func set_monitoring(on: bool) -> void:
	area_.monitoring = on

func set_monitorable(on: bool) -> void:
	area_.monitorable = on
