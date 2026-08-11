class_name PlaceableComponent extends Component

@export var boundingbox: CArea3D
@export var mesh: MeshInstance3D

const HOLOGRAM_MATERIAL = preload("uid://b1pjmlx7yv3kh")
var default_material: StandardMaterial3D
const HOLO_COLLIDING_MATERIAL = preload("uid://cifpae7kfm0p8")

var placed: bool = false
var holo: bool = true
var placeable: bool = false

func _init_component() -> void:
	default_material = mesh.material_override
	if !entity.has_component(StructureComponent):
		push_error("Cannot place an entity that does not have a structurecomponent")

func place() -> void:
	if placeable and holo and !placed:
		placed = true
		holo = false
		mesh.set_surface_override_material(0, default_material)
		boundingbox.cset_collision_layer_value(5, true)
		boundingbox.monitorable = true
		boundingbox.monitoring = false
		boundingbox.set_collision_layer_value(5, true)

func place_check() -> void:
	# In build_box.gd inside can_be_placed():
	var space_state: PhysicsDirectSpaceState3D = mesh.get_world_3d().direct_space_state
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()

	# Create a slightly shrunk copy of the shape for the query
	var shape_node: CollisionShape3D = boundingbox.get_node("CollisionShape3D") as CollisionShape3D
	var check_shape: Shape3D = shape_node.shape.duplicate()

	# Prevent collision when reaaaally close to each other
	if check_shape is BoxShape3D:
		check_shape.size -= Vector3(0.02, 0.02, 0.02)

	query.shape = check_shape
	query.transform = boundingbox.global_transform
	query.collision_mask = boundingbox.collision_mask
	query.exclude = [boundingbox.get_rid(), boundingbox.get_rid()]
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var hits: Array[Dictionary] = space_state.intersect_shape(query, 1)
	if hits.size() != 0:
		mesh.set_surface_override_material(0, HOLO_COLLIDING_MATERIAL)
		placeable = false
		return
	placeable = true
	mesh.set_surface_override_material(0, HOLOGRAM_MATERIAL)
