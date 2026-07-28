@tool
class_name CMeshInstance3D extends MeshInstance3D

@export var entity: Entity
@export var target_component: String


func _get_property_list() -> Array[Dictionary]:
	return InspectorHelp.get_target_components_property(get_script())
