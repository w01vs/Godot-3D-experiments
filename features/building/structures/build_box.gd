class_name BuildBox extends StaticBody3D

@onready var mesh_: MeshInstance3D = $".."

const HOLOGRAM_MATERIAL = preload("uid://b1pjmlx7yv3kh")
const DEFAULT_MATERIAL = preload("uid://db2oa1m56af12")
const HOLO_COLLIDING_MATERIAL = preload("uid://cifpae7kfm0p8")

var holo: bool = false

var placeable: bool = false

var placed: bool = false

var collider_count: int = 0
	
var time_margin: float = 0.08

var timer_running: bool = true

var timer_current: float = 0

@export var snap: bool

@onready var area: Area3D = $"../BuildDetection"

func _ready() -> void:
	mesh_.set_surface_override_material(0, DEFAULT_MATERIAL)
	area.connect("area_entered", _on_area_3d_area_entered)
	area.connect("area_exited", _on_area_3d_area_exited)

func to_holo() -> void:
	if not holo:
		holo = true
		place_check()

func place() -> void:
	if holo:
		placed = true
		holo = false
		mesh_.set_surface_override_material(0, DEFAULT_MATERIAL)
		set_collision_layer_value(5, true)
		area.disconnect("area_entered", _on_area_3d_area_entered)
		area.disconnect("area_exited", _on_area_3d_area_exited)
		area.monitorable = true
		area.monitoring = false
		area.set_collision_layer_value(1, true)

func place_check() -> void:
	# In build_box.gd inside can_be_placed():
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()

	# Create a slightly shrunk copy of the shape for the query
	var shape_node: CollisionShape3D = area.get_node("CollisionShape3D")
	var check_shape:  = shape_node.shape.duplicate()

	# Prevent collision when reaaaally close to each other
	if check_shape is BoxShape3D:
		check_shape.size -= Vector3(0.04, 0.04, 0.04)

	query.shape = check_shape
	query.transform = global_transform
	query.collision_mask = area.collision_mask
	query.exclude = [self.get_rid(), area.get_rid()]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var hits: Array[Dictionary] = space_state.intersect_shape(query, 1)
	if hits.size() != 0:
		print_debug(hits)
		mesh_.set_surface_override_material(0, HOLO_COLLIDING_MATERIAL)
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

func _on_area_3d_area_entered(_area: Area3D) -> void:
	collider_count += 1
	if placeable:
		placeable = false
		mesh_.set_surface_override_material(0, HOLO_COLLIDING_MATERIAL)
	print_debug(collider_count)

func _on_area_3d_area_exited(_area: Area3D) -> void:
	collider_count -= 1
	if collider_count == 0:
		timer_current = 0
		timer_running = true
	print_debug(collider_count)

func reset_placement_check() -> void:
	placeable = false
	timer_running = false
	timer_current = 0.0
	place_check()
