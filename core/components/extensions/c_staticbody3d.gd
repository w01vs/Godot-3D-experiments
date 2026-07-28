@tool
class_name CStaticBody3D extends StaticBody3D

@export var entity: Entity
@export var target_components: Array[String]

func _ready() -> void:
	assert(entity != null)
	entity.raise_local(CollisionShapeRegisteredEntityEvent.new(self, target_components))

func _get_property_list() -> Array[Dictionary]:
	return InspectorHelp.get_target_components_property(get_script())
