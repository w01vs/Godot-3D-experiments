class_name CMeshInstance3D extends MeshInstance3D

@export var entity: Entity
var target_components: Array[StringName]

func _ready() -> void:
	if !Engine.is_editor_hint():
		pass
