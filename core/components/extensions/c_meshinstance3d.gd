class_name CMeshInstance3D extends MeshInstance3D

@export var entity: Entity

func _ready() -> void:
	if !Engine.is_editor_hint():
		#add_to_group("custom_collision_object")
		pass
