class_name AnimationTypeChangeEntityEvent extends EntityEvent

var type: StringName

func _init(source_: Node, type_: StringName) -> void:
	super(source_)
	type = type_
