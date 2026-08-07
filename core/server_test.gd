extends Node3D

var visual_rid: RID
var body_rid: RID
var shape_rid: RID
var mesh: BoxMesh

func _ready() -> void:
	var box_size: Vector3 = Vector3(2.0, 2.0, 2.0)
	var spawn_transform: Transform3D = Transform3D(Basis.IDENTITY, Vector3(0, 0, 0))
	
	# Rendering
	mesh = BoxMesh.new()
	mesh.size = box_size
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mesh.material = mat
	
	visual_rid = RenderingServer.instance_create()
	RenderingServer.instance_set_scenario(visual_rid, get_world_3d().scenario)
	RenderingServer.instance_set_base(visual_rid, mesh)
	RenderingServer.instance_set_transform(visual_rid, spawn_transform)
	
	# Collision
	shape_rid = PhysicsServer3D.box_shape_create()
	PhysicsServer3D.shape_set_data(shape_rid, Vector3(1.0, 1.0, 1.0))
	
	body_rid = PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_space(body_rid, get_world_3d().space)
	PhysicsServer3D.body_set_mode(body_rid, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_add_shape(body_rid, shape_rid)
	PhysicsServer3D.body_set_state(body_rid, PhysicsServer3D.BODY_STATE_TRANSFORM, spawn_transform)
	PhysicsServer3D.body_set_collision_layer(body_rid, CollisionLayer.TERRAIN | CollisionLayer.INTERACTABLE)

func _exit_tree() -> void:
	if visual_rid.is_valid():
		RenderingServer.free_rid(visual_rid)
	if body_rid.is_valid():
		PhysicsServer3D.free_rid(body_rid)
	if shape_rid.is_valid():
		PhysicsServer3D.free_rid(shape_rid)
