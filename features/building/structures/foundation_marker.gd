@tool
class_name FoundationMarker extends Node3D

@export var box_shape_node: CollisionShape3D

var markers: Array[Marker3D]

@export_tool_button("Generate corner markers", "") var gen: Callable = proxy
@export_tool_button("Update Y-level of markers", "") var update: Callable = y_update_markers

func proxy() -> void:
	_generate_80_percent_markers()

func _generate_80_percent_markers() -> void:
	if not box_shape_node or not (box_shape_node.shape is BoxShape3D):
		push_warning("Please assign a CollisionShape3D containing a BoxShape3D first.")
		return

	var container_name: StringName = &"CornerMarkers"
	var existing_container: Node = find_child(container_name, false, false)
	if existing_container:
		existing_container.free()

	var container: Node3D = Node3D.new()
	container.name = container_name
	add_child(container)
	container.owner = EditorInterface.get_edited_scene_root()

	var box_shape := box_shape_node.shape as BoxShape3D
	var local_scale := box_shape_node.scale
	var real_size := box_shape.size * local_scale

	var half_x := (real_size.x / 2.0) * 0.8
	var half_z := (real_size.z / 2.0) * 0.8
	var bottom_y := -real_size.y / 2.0

	var local_corners: Array[Vector3] = [
		Vector3(-half_x, bottom_y, -half_z), # Top-Left
		Vector3( half_x, bottom_y, -half_z), # Top-Right
		Vector3(-half_x, bottom_y,  half_z), # Bottom-Left
		Vector3( half_x, bottom_y,  half_z), # Bottom-Right
		Vector3(global_position.x, bottom_y, global_position.z)
	]

	for i in range(local_corners.size()):
		var marker := Marker3D.new()
		marker.name = "CornerMarker%d" % (i + 1)
		container.add_child(marker)
		
		marker.position = local_corners[i]
		marker.owner = EditorInterface.get_edited_scene_root()

	print_rich("[color=green]Successfully generated 4 corner Marker3D nodes and a center Marker3D node.[/color]")

func y_update_markers() -> void:
	var box_shape := box_shape_node.shape as BoxShape3D
	var local_scale := box_shape_node.scale
	var real_size := box_shape.size * local_scale
	var bottom_y := -real_size.y / 2.0
	for marker in markers:
		marker.global_position.y = bottom_y

func gather_markers() -> void:
	var container: Node = find_child("CornerMarkers")
	for node in container.find_children("*", "Marker3D", false, true):
		markers.append(node)

func _ready() -> void:
	gather_markers()
	
