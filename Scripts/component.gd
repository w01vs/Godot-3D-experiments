@abstract class_name Component extends Node

var registered: Array[Node]
var type: StringName

func _ready() -> void:
	_init_component()

func _init_component() -> void:
	pass

func register(node: Node) -> void:
	node.set_meta(type, self)
	registered.append(node)

func unregister() -> void:
	for node in registered:
		if is_instance_valid(node):
			node.remove_meta(type)
	registered.clear()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		unregister()
