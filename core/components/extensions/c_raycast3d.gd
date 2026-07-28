@tool
class_name CRayCast3D extends RayCast3D

@export var entity: Entity
@export var target_component: String

func _ready() -> void:
	entity.raise_local(RayCastRegisteredEntityEvent.new(self))

func _get_property_list() -> Array[Dictionary]:
	return InspectorHelp.get_target_components_property(get_script())
