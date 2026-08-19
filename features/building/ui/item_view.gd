class_name UIBuildItemView extends RefCounted

var name: StringName
var icon: Texture2D
var group: BuildGroup
var id: int

func _init(name_: StringName, icon_: Texture2D, group_: BuildGroup, id_: int) -> void:
	name = name_
	icon = icon_
	group = group_
	id = id_
