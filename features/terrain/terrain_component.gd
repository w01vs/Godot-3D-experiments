class_name TerrainComponent extends Component

@export var body: CStaticBody3D

func _init_component() -> void:
	entity.subscribe(self, CollisionShapeRegisteredEntityEvent, _on_collision_shape_registered)

func _on_collision_shape_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if body == event.source:
		body.cset_collision_layer_value(CollisionLayer.TERRAIN, true)
