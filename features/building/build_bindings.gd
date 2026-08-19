class_name BuildBindings extends Node

var select: Callable

func _init(select_: Callable) -> void:
	select = select_
