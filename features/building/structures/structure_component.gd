class_name StructureComponent extends Component

@export var body: CStaticBody3D

func init_component() -> void:
	body.cset_collision_layer_value(CollisionLayer.STRUCTURE, true)
