class_name TerrainComponent extends Component

@export var body: CStaticBody3D

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_collision_shape_registered)

func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if body == event.source:
		body.cset_collision_layer_value(CollisionLayer.TERRAIN, true)
		body.cset_collision_layer_value(CollisionLayer.ENTITY, true)
		body.cset_collision_layer_value(CollisionLayer.STRUCTURE, true)
		body.cset_collision_layer_value(CollisionLayer.HARVESTABLE, true)
