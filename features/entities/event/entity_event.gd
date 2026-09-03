@abstract class_name EntityEvent extends EventBase

var _type: Script

func _init(source_: Node) -> void:
	super(source_)
	_type = get_script()
