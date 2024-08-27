class_name BuildBox extends MeshInstance3D

var mat: Material = preload("res://hologram_material.tres")

var default_mat: Material = preload("res://default_material.tres")

var err_mat: Material = preload("res://holo_collidiing_material.tres")

var holo: bool = false

var placeable: bool = true

var placed: bool = false

var collider_count: int = 0

var time_margin: float = 0.08

var timer_running: bool = false

var timer_current: float = 0

func _ready() -> void:
	set_surface_override_material(0, default_mat)

func to_holo() -> void:
	if not holo:
		holo = true
		set_surface_override_material(0, mat)

func place() -> void:
	if holo:
		placed = true
		holo = false
		set_surface_override_material(0, default_mat)
		$StaticBody3D.set_collision_layer_value(5, true)
		$Area3D.disconnect("area_entered", _on_area_3d_area_entered)
		$Area3D.disconnect("area_exited", _on_area_3d_area_exited)
		$Area3D.disconnect("body_entered", _on_area_3d_body_entered)
		$Area3D.disconnect("body_exited", _on_area_3d_body_exited)
		$Area3D.disconnect("area_shape_entered", _on_area_3d_area_shape_entered)
		$Area3D.disconnect("area_shape_exited", _on_area_3d_area_shape_exited)
		$Area3D.disconnect("body_shape_entered", _on_area_3d_body_shape_entered)
		$Area3D.disconnect("body_shape_exited", _on_area_3d_body_shape_exited)
		$Area3D.monitorable = true
		$Area3D.set_collision_layer_value(1, true)

func _process(delta: float) -> void:
	if timer_running:
		timer_current += delta
		if timer_current > time_margin:
			placeable = true
			set_surface_override_material(0, mat)
			timer_running = false

func _on_area_3d_area_entered(area):
	collider_count += 1
	if placeable:
		set_surface_override_material(0, err_mat)
		placeable = false

func _on_area_3d_area_exited(area):
	collider_count -= 1
	if collider_count == 0:
		timer_current = 0
		timer_running = true

func _on_area_3d_body_entered(body):
	collider_count += 1
	if placeable:
		set_surface_override_material(0, err_mat)
		placeable = false

func _on_area_3d_body_exited(body):
	collider_count -= 1
	if collider_count == 0:
		timer_current = 0
		timer_running = true

func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	collider_count += 1
	if placeable:
		set_surface_override_material(0, err_mat)
		placeable = false

func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	collider_count -= 1
	if collider_count == 0:
		timer_current = 0
		timer_running = true

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	collider_count += 1
	if placeable:
		set_surface_override_material(0, err_mat)
		placeable = false

func _on_area_3d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	collider_count -= 1
	if collider_count == 0:
		timer_current = 0
		timer_running = true
