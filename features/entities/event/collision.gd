@abstract class_name CollisionEntityEvent extends EntityEvent

var data: CollisionData

func _init(source_: Node, data_: CollisionData) -> void:
	super(source_)
	data = data_
