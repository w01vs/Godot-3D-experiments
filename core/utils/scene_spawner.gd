@tool
extends Node3D

@export var tree_scene: PackedScene
@export var terrain3d: Node3D # Drag your Terrain3D node here

@export_range(1.0, 1000.0) var spawn_radius: float = 20.0:
	set(value):
		spawn_radius = value
		_update_visual_circle()

@export_range(0.0, 2.0) var ring_height_offset: float = 0.3:
	set(value):
		ring_height_offset = value
		_update_visual_circle()

@export_range(0.5, 5.0) var min_scale: float = 1.0:
	set(value):
		if value > max_scale:
			max_scale = value
		min_scale = value
		
@export_range(0.5, 5.0) var max_scale: float = 1.0:
	set(value):
		if value < min_scale:
			min_scale = value
		max_scale = value

@export var always_draw_on_top: bool = true:
	set(value):
		always_draw_on_top = value
		_update_material()

@export var spawn_count: int = 15

@export_tool_button("Spawn trees", "") var spawn_action: Callable = respawn
@export_tool_button("Clear", "") var clear_action: Callable = clear

func clear() -> void:
	_clear_trees()
	notify_property_list_changed()

func respawn() -> void:
	_clear_trees()
	_spawn_trees()
	notify_property_list_changed()

var _circle_mesh: MeshInstance3D
var _circle_material: StandardMaterial3D

func _ready() -> void:
	if Engine.is_editor_hint():
		_setup_visual_circle()

func _setup_visual_circle() -> void:
	if not _circle_mesh:
		_circle_mesh = MeshInstance3D.new()
		add_child(_circle_mesh)
		
		_circle_material = StandardMaterial3D.new()
		_circle_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_circle_material.albedo_color = Color(0.2, 0.8, 1.0, 0.9)
		_update_material()
		_circle_mesh.material_override = _circle_material

	_update_visual_circle()

func _update_material() -> void:
	if _circle_material:
		_circle_material.no_depth_test = always_draw_on_top

func _update_visual_circle() -> void:
	if not Engine.is_editor_hint() or not is_inside_tree():
		return

	if not _circle_mesh:
		_setup_visual_circle()
		return

	var imm_mesh := ImmediateMesh.new()
	imm_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	var segments := 128
	for i in range(segments + 1):
		var theta := (float(i) / float(segments)) * TAU
		var x := cos(theta) * spawn_radius
		var z := sin(theta) * spawn_radius
		
		var world_sample_pos := global_position + Vector3(x, 0, z)
		var h_local := 0.0
		
		if terrain3d and terrain3d.get("data") and terrain3d.data:
			var sampled_h: float = terrain3d.data.get_height(world_sample_pos)
			if not is_nan(sampled_h):
				h_local = sampled_h - global_position.y
				
		imm_mesh.surface_add_vertex(Vector3(x, h_local + ring_height_offset, z))
		
	imm_mesh.surface_end()
	_circle_mesh.mesh = imm_mesh

func _clear_trees() -> void:
	for child in get_children():
		if child == _circle_mesh:
			continue
		child.queue_free()

func _spawn_trees() -> void:
	if not Engine.is_editor_hint():
		return

	if not tree_scene or not terrain3d or not terrain3d.get("data") or not terrain3d.data:
		printerr("Missing scene or Terrain3D assignment!")
		return

	var undo_redo := EditorInterface.get_editor_undo_redo()

	undo_redo.create_action("Spawn Trees")

	var spawned := 0

	for i in range(spawn_count):
		var r := spawn_radius * sqrt(randf())
		var theta := randf_range(0, TAU)

		var offset_x := r * cos(theta)
		var offset_z := r * sin(theta)

		var target_pos := global_position + Vector3(offset_x, 0.0, offset_z)

		var height: float = terrain3d.data.get_height(target_pos)

		if is_nan(height):
			continue

		target_pos.y = height

		var instance := tree_scene.instantiate() as Node3D
		instance.process_mode = Node.PROCESS_MODE_PAUSABLE

		var random_rotation := randf_range(0, TAU)
		var scale_factor := randf_range(min_scale, max_scale)

		undo_redo.add_do_method(self, "add_child", instance)
		undo_redo.add_do_method(
			instance,
			"set_owner",
			get_tree().edited_scene_root
		)
		undo_redo.add_do_property(
			instance,
			"global_position",
			target_pos
		)
		undo_redo.add_do_property(
			instance,
			"rotation:y",
			random_rotation
		)
		undo_redo.add_do_property(
			instance,
			"scale",
			Vector3.ONE * scale_factor
		)

		undo_redo.add_undo_method(
			self,
			"remove_child",
			instance
		)
		undo_redo.add_undo_method(
			instance,
			"queue_free"
		)

		spawned += 1

	undo_redo.commit_action()

	print("Successfully spawned %d scenes!" % spawned)
