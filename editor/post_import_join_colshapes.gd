@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	var c_static_body := CStaticBody3D.new()
	c_static_body.name = "CStaticBody3D"

	var entity: Entity = Entity.new()
	entity.name = scene.name + "_root"
	
	c_static_body.entity = entity
	for child in scene.get_children():
		scene.remove_child(child)
		entity.add_child(child)
	
	scene = entity

	var bodies_to_remove: Array[StaticBody3D] = []
	_find_static_bodies(scene, bodies_to_remove)

	if bodies_to_remove.is_empty():
		return scene

	# Add custom static body temporarily to the imported scene
	scene.add_child(c_static_body)
	c_static_body.owner = scene

	for body in bodies_to_remove:
		var body_transform: Transform3D = body.transform
		var children := body.get_children()

		for child in children:
			if not (child is Node3D):
				continue

			var child_3d := child as Node3D
			var target_local_transform: Transform3D = body_transform * child_3d.transform

			child_3d.owner = null
			body.remove_child(child_3d)

			if child_3d is CollisionShape3D:
				_sanitize_collision_scale(child_3d as CollisionShape3D)

				c_static_body.add_child(child_3d)
			else:
				# Visual nodes stay beside CStaticBody3D
				scene.add_child(child_3d)

			child_3d.transform = target_local_transform
			child_3d.owner = scene

		body.free()

	# Set entity reference
	c_static_body.entity = entity

	# Create Entity root
	var children_to_move := scene.get_children().duplicate()

	scene.remove_child(c_static_body)

	for child in children_to_move:
		if child == c_static_body:
			continue

		scene.remove_child(child)
		entity.add_child(child)
		child.owner = entity

	entity.add_child(c_static_body)
	c_static_body.owner = entity

	return entity


func _find_static_bodies(node: Node, result: Array[StaticBody3D]) -> void:
	if node is StaticBody3D:
		result.append(node)

	for child in node.get_children():
		_find_static_bodies(child, result)


func _sanitize_collision_scale(shape_node: CollisionShape3D) -> void:
	var s := shape_node.scale

	if s.is_equal_approx(Vector3.ONE):
		return

	shape_node.shape = shape_node.shape.duplicate()

	if shape_node.shape is ConvexPolygonShape3D:
		var convex := shape_node.shape as ConvexPolygonShape3D
		var points := convex.points

		for i in range(points.size()):
			points[i] *= s

		convex.points = points

	elif shape_node.shape is BoxShape3D:
		var box := shape_node.shape as BoxShape3D
		box.size *= s

	elif shape_node.shape is CylinderShape3D:
		var cyl := shape_node.shape as CylinderShape3D
		cyl.height *= s.y
		cyl.radius *= max(s.x, s.z)

	shape_node.scale = Vector3.ONE
