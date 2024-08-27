class_name BuildBox extends MeshInstance3D

var mat: Material = preload("res://hologram_material.tres")

var default_mat: Material = preload("res://default_material.tres")

var holo: bool = false

func _ready() -> void:
	set_surface_override_material(0, default_mat)

func to_holo() -> void:
	if not holo:
		holo = true
		set_surface_override_material(0, mat)
		$StaticBody3D.set_collision_layer_value(5, false)
		$StaticBody3D.set_collision_mask_value(1, false)
		$StaticBody3D.set_collision_mask_value(5, false)

func place() -> void:
	if holo:
		holo = false
		set_surface_override_material(0, default_mat)
		$StaticBody3D.set_collision_layer_value(5, true)
		$StaticBody3D.set_collision_mask_value(1, true)
		$StaticBody3D.set_collision_mask_value(5, true)
