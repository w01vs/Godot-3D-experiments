@abstract class_name Event extends RefCounted

enum Priority { 
	PRE = -1,
	BASE = 0,
	POST = 1,
}

var source: Node3D

func _init(_source: Node3D) -> void:
	source = _source
