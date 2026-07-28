class_name HurtboxComponent extends Component

@export var area: CArea3D

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_area_connected)

func _on_area_connected(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CArea3D and event.target_components.has(script_name):
		area.set_collision_layer_value(3, true)
		area.hit.connect(hit)
		area.monitorable = true

func hit(data: AreaData) -> void:
	if data is HitData:
		entity.raise_local(DamageEntityEvent.new(self, data.info, data.source))

static func _get_tags() -> Set:
	var tags: Set = Set.new()
	tags.add(CArea3D)
	return tags
