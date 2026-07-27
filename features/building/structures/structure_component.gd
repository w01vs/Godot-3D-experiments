class_name StructureComponent extends Component

@export var collision_area: CArea3D
@export var mesh_: GeometryInstance3D
@export var body: StaticBody3D

const DEFAULT_MATERIAL = preload("uid://db2oa1m56af12")
const HOLOGRAM_MATERIAL = preload("uid://b1pjmlx7yv3kh")
const HOLO_COLLIDIING_MATERIAL = preload("uid://cifpae7kfm0p8")

var holo: bool = false
var placed: bool = false
var placeable: bool = false
var timer_running: bool = true
var snapping: bool = false

var collider_count: int = 0

var time_margin: float = 0.08
var timer_current: float = 0

func _init_component() -> void:
	mesh_.set_surface_override_material(0, DEFAULT_MATERIAL)

func to_holo() -> void:
	if not holo:
		holo = true
		place_check()

func place() -> void:
	if holo:
		placed = true
		holo = false
		mesh_.set_surface_override_material(0, DEFAULT_MATERIAL)
		body.set_collision_layer_value(5, true)
		collision_area.monitorable = true
		collision_area.monitoring = false
		collision_area.set_collision_layer_value(5, true)

func place_check() -> void:
	# In build_box.gd inside can_be_placed():
	var space_state: PhysicsDirectSpaceState3D = body.get_world_3d().direct_space_state
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()

	# Create a slightly shrunk copy of the shape for the query
	var shape_node: CollisionShape3D = collision_area.get_node("CollisionShape3D") as CollisionShape3D
	var check_shape: Shape3D = shape_node.shape.duplicate()

	# Prevent collision when reaaaally close to each other
	if check_shape is BoxShape3D:
		check_shape.size -= Vector3(0.02, 0.02, 0.02)

	query.shape = check_shape
	query.transform = body.global_transform
	query.collision_mask = collision_area.collision_mask
	query.exclude = [body.get_rid(), collision_area.get_rid()]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var hits: Array[Dictionary] = space_state.intersect_shape(query, 1)
	if hits.size() != 0:
		mesh_.set_surface_override_material(0, HOLO_COLLIDIING_MATERIAL)
		placeable = false
		return
	mesh_.set_surface_override_material(0, HOLOGRAM_MATERIAL)
	placeable = true

func _process(delta: float) -> void:
	if timer_running and !placed:
		timer_current += delta
		if timer_current > time_margin:
			placeable = true
			mesh_.set_surface_override_material(0, HOLOGRAM_MATERIAL)
			timer_running = false

func reset_placement_check() -> void:
	placeable = false
	place_check()

func moveto(target: Vector3) -> void:
	entity.root3d.global_position = target

func set_visible(on: bool) -> void:
	mesh_.visible = on

static func _get_tags() -> Set:
	var tags: Set = Set.new()
	tags.add(CArea3D)
	tags.add(CMeshInstance3D)
	tags.add(CStaticBody3D)
	return tags
