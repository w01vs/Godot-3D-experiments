class_name HurtboxComponent extends Component

@export var area: CArea3D

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_area_connected)
	entity.subscribe_local(CollisionEntityEvent, hit)

func _on_area_connected(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CArea3D and event.source.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT):
		area.set_collision_layer_value(3, true)
		area.monitorable = true

func hit(data: CollisionData) -> void:
	if data is HitData:
		entity.raise_local(DamageEntityEvent.new(self, data.info, data.source))
