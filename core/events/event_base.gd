@abstract class_name EventBase extends EventBaseGD

enum Priority { 
	PRE = -1,
	BASE = 0,
	POST = 1,
}

func _init(source_: Node) -> void:
	source = source_ 
	var scr: Script = get_script()
	if scr:
		debug_id = scr.get_instance_id()
