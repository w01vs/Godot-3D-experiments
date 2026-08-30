class_name TerrainComponent extends Component

@export var body: CStaticBody3D

func _init_component() -> void:
	_init_body()

func _init_body() -> void:
	body.cset_collision_layer_value(CollisionLayer.TERRAIN, true)
