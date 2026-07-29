@abstract class_name EventBase extends RefCounted

enum Priority { 
	PRE = -1,
	BASE = 0,
	POST = 1,
}

var source: Node
var id: int

func _init(source_: Node) -> void:
	source = source_ 
	id = get_script().get_instance_id()
