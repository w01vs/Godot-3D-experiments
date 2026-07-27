class_name CollisionShapeRegisteredEntityEvent extends EntityEvent

var target_component: String

func _init(_source: Node, target: String) -> void:
	super(_source)
	target_component = target
