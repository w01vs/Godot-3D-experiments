class_name CollisionShapeRegisteredEntityEvent extends EntityEvent

var target_components: Array[String]

func _init(_source: Node, target: Array[String]) -> void:
	super(_source)
	target_components = target
