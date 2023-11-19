class_name BTNode extends Node

enum {SUCCESS, FAILED, RUNNING}

var children: Array[BTNode]
var priority: int

func get_bt_children() -> void:
	var nodeChildren = get_children()
	for i in nodeChildren:
		children.append(i)
	children.sort_custom(compare)

func compare(a, b) -> bool:
	return a.priority < b.priority

func disable() -> void:
	for i in children:
		i.disable()
	set_physics_process(false)
	set_process(false)
