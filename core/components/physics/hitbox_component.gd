class_name HitboxComponent extends Component

@export var area: CArea3D
 
var damage_info: DamageInfo

func _init_component() -> void:
	entity.subscribe_local(self, CollisionShapeRegisteredEntityEvent, _on_area_set)

func _on_area_set(event: CollisionShapeRegisteredEntityEvent) -> void:
	if area == event.source:
		area.set_collision_mask_value(CollisionLayer.HURTBOX, true)
		area.area_entered.connect(_on_area_entered)
		area.body_entered.connect(_on_body_entered)

func _on_area_entered(area_: Area3D) -> void:
	if area_ is CArea3D:
		area.hit(HitData.new(entity, damage_info))

func _on_body_entered(body: PhysicsBody3D) -> void:
	if body is CStaticBody3D:
		body.hit(HitData.new(entity, damage_info))

func set_monitoring(on: bool) -> void:
	area.monitoring = on

func set_monitorable(on: bool) -> void:
	area.monitorable = on
