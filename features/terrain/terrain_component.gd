class_name TerrainComponent extends Component

@export var body: CStaticBody3D

func _init_component() -> void:
	_init_body()
	var root: GDScript = load("res://features/entities/event/entity_event.gd") as GDScript
	var child: GDScript = load("res://features/entities/event/collision.gd") as GDScript
	var instance: EntityEvent = root.new(self)
	var child_instance: CollisionEntityEvent = child.new(self, InteractionData.new(entity))
	print(child_instance.get_script() == instance.get_script())

func _init_body() -> void:
	body.cset_collision_layer_value(CollisionLayer.TERRAIN, true)
