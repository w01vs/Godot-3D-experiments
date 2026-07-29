class_name RayCastEntityEvent extends EntityEvent

var collider: Object

func _init(source_: Node, collider_: Object) -> void:
	super(source_)
	collider = collider_ 
