class_name HurtboxComponent extends Component

@export var area: CollisionObject3D

func _init_component() -> void:
	entity.subscribe_local(self, CollisionShapeRegisteredEntityEvent, _on_area_connected)
	entity.subscribe_local(self, CollisionEntityEvent, hit)

func _on_area_connected(event: CollisionShapeRegisteredEntityEvent) -> void:
	if area == event.source:
		area.set_collision_layer_value(CollisionLayer.HURTBOX, true)
	if event.source is CArea3D:
		area.monitorable = true

func hit(data: CollisionData) -> void:
	if data is HitData:
		entity.raise_local(DamageEntityEvent.new(self, data.info, data.source))
