class_name StructureComponent extends Component

@export var body: CStaticBody3D
var id: int

func set_id(id_: int) -> void:
	id = id_

func _init_component() -> void:
	enable()
	set_collision(true)

func set_collision(on: bool) -> void:
	body.cset_collision_layer_value(CollisionLayer.STRUCTURE, on)

func show() -> void:
	entity.show()

func hide() -> void:
	entity.hide()
