## By default triggers collision events on enter.
## [br] Optionally also enable events on exit
class_name HarvesterComponent extends Component

@export var area: CArea3D
 
var damage_info: DamageInfo

func _init_component() -> void:
	_init_area()

func _init_area() -> void:
	area.set_collision_mask_value(CollisionLayer.HARVESTABLE, true)
	area.area_entered.connect(_on_area_entered)
	area.body_entered.connect(_on_body_entered)

func _on_area_entered(area_: Area3D) -> void:
	if area_ is CArea3D:
		area.enter(HitData.new(entity, damage_info))

func _on_body_entered(body: PhysicsBody3D) -> void:
	if body is CStaticBody3D:
		body.enter(HitData.new(entity, damage_info))

func set_monitoring(on: bool) -> void:
	area.monitoring = on

func set_monitorable(on: bool) -> void:
	area.monitorable = on
