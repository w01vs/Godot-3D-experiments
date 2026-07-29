class_name TerrainComponent extends Component

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_collision_shape_registered)

func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source.get_groups().has(Groups.CUSTOM_COLLISION_OBJECT) and event.source is CStaticBody3D:
		var body: CStaticBody3D = event.source as CStaticBody3D
		body.cset_collision_layer_value(1, true)
