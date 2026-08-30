@tool
extends EditorPlugin

var height = 1
var offset = 0.7
var mesh: MeshInstance3D = null
var toolbar_button: Button
var ring_name := "RingRenderer"

func _enter_tree() -> void:
	toolbar_button = Button.new()
	toolbar_button.text = "Generate Ring"
	toolbar_button.flat = true
	toolbar_button.pressed.connect(_on_toolbar_pressed)
	
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, toolbar_button)
	toolbar_button.hide()


func _handles(object: Object) -> bool:
	return object is MeshInstance3D and object is not RibbonMeshInstance3D

func _edit(object: Object) -> void:
	if object is MeshInstance3D and object is not RibbonMeshInstance3D:
		mesh = object as MeshInstance3D
	else:
		mesh = null

func _make_visible(visible: bool) -> void:
	if toolbar_button:
		toolbar_button.visible = visible

func _on_toolbar_pressed() -> void:
	var faces: PackedVector3Array = mesh.mesh.get_faces()
	faces.sort()
	var aabb: AABB = mesh.get_aabb()
	var local_bottom_center := Vector3(
		aabb.position.x + aabb.size.x * 0.5,
		aabb.position.y, # Lowest point on Y-axis
		aabb.position.z + aabb.size.z * 0.5
	)
	var world_bottom_pos: Vector3 = mesh.global_transform * local_bottom_center
	var world_height: float = aabb.size.y * mesh.global_transform.basis.get_scale().y
	var vertices_2d: PackedVector2Array = []
	var height_percent = height / world_height
	var height_offset = 0.5 / world_height
	var relevant_vertices
	for vertex in faces:
		if vertex.y <= (height_percent + height_offset):
			vertex *= mesh.global_transform
			vertices_2d.append(Vector2(vertex.x, vertex.z))
	var convex_hull2d: PackedVector2Array = Geometry2D.convex_hull(vertices_2d)
	convex_hull2d.reverse()
	var dedup_convex_hull: PackedVector2Array = []
	for pt in convex_hull2d:
		if !dedup_convex_hull.has(pt):
			dedup_convex_hull.append(pt)
	var offset_hull: Array[PackedVector2Array] = Geometry2D.offset_polygon(convex_hull2d, offset, Geometry2D.JOIN_ROUND)
	var world_bottom_y: float = (mesh.global_transform * aabb.position).y
	var target_y: float = world_bottom_y + height
	
	var ring_3d: PackedVector3Array = []
	for vertex2d in offset_hull[0]:
		ring_3d.append(Vector3(vertex2d.x, target_y, vertex2d.y))
	
	var node := RibbonMeshInstance3D.new(ring_3d)
	node.name = ring_name
	mesh.set_meta("ring", ring_3d)
	add_ring_renderer_node(node)

func add_ring_renderer_node(node: RibbonMeshInstance3D) -> void:
	if not mesh:
		return
	# Get the current edited scene root (required for saving)
	var scene_root: Node = get_tree().edited_scene_root
	if not scene_root:
		push_error("No active scene root found!")
		return

	# 2. Access the Editor UndoRedo Manager
	var undo_redo: EditorUndoRedoManager = get_undo_redo()
	
	# 3. Create the Undo/Redo Action
	undo_redo.create_action("Add Ring Renderer Node")
	if mesh.has_node(ring_name):
		undo_redo.add_do_method(mesh, "remove_child", mesh.get_node(ring_name))

	# DO Action: Add child and assign owner so Godot saves it into the scene file
	undo_redo.add_do_method(mesh, "add_child", node)
	undo_redo.add_do_method(node, "set_owner", scene_root)
	undo_redo.add_do_reference(node) # Prevents memory leaks if undone before saving

	# UNDO Action: Remove child from tree
	undo_redo.add_undo_method(mesh, "remove_child", node)

	# 4. Commit and execute
	undo_redo.commit_action()
