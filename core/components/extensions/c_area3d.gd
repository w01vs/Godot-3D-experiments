@tool
class_name CArea3D extends Area3D

@warning_ignore("unused_signal")
signal hit(data: AreaData)

@export var entity: Entity
var target_components: Array[String] = []

func _ready() -> void:
	assert(entity != null)
	entity.raise_local(CollisionShapeRegisteredEntityEvent.new(self, target_components))
	collision_layer = 0
	collision_mask = 0
	monitorable = false
	monitoring = false

func _get_property_list() -> Array[Dictionary]:
	return InspectorHelp.get_target_components_property(get_script())
