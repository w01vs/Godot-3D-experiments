@abstract class_name InteractionComponent extends Component

@export var area: ComponentArea3D

func _init_component() -> void:
	area.collision_layer = 0
	area.set_collision_layer_value(2, true)
	area.area_entered.connect(_interact)

func _interact(interacter: Entity) -> void:
	pass
