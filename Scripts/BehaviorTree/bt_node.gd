class_name BTNode extends Node

enum {SUCCESS = 1, FAILED = -1, RUNNING = 0}

@export var priority: int = 0

var children: Array[BTNode]

func get_bt_children() -> void:
	var nodeChildren = get_children()
	for child in nodeChildren:
		children.append(child)
		child.set_physics_process(false)
		child.set_process(false)
	children.sort_custom(compare)

func compare(a: BTNode, b: BTNode) -> bool:
	return a.priority > b.priority

func execute() -> int:
	return FAILED

func disable() -> void:
	for i in children:
		i.disable()
	set_physics_process(false)
	set_process(false)
