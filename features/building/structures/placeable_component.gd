class_name PlaceableComponent extends Component

@export var boundingbox: CArea3D
@export var boundingbox_shape: CollisionShape3D
var box_shape: BoxShape3D
@export var meshes: Array[MeshInstance3D]
@export var hidden_while_placing: Array[MeshInstance3D]
@export var body: CStaticBody3D

@export var HOLOGRAM_MATERIAL: StandardMaterial3D
var default_mats: Array[StandardMaterial3D]
@export var HOLO_COLLIDING_MATERIAL: StandardMaterial3D

@export_group("Foundation requirement")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var use_foundation: bool = false
@export var foundation: FoundationMarker
@export_range(0.05, 5, 0.05) var support_range: float = 0.05


var placed: bool = false
var holo: bool = true
var placeable: bool = false

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	assert(!use_foundation || (use_foundation and foundation))
	if use_foundation and !foundation:
		push_error("No FoundationMarker selected.")
	if !entity.has_component(StructureComponent):
		push_error("Cannot place an entity that does not have a structurecomponent")
	default_mats.resize(meshes.size())
	for i in meshes.size():
		default_mats[i] = meshes[i].material_override
	for mesh in hidden_while_placing:
		mesh.hide()
	if !boundingbox_shape.shape is BoxShape3D:
		push_error("Bounding box is not a BoxShape3D at %s" % [str(self)])
	assert(boundingbox_shape.shape is BoxShape3D)
	box_shape = boundingbox_shape.shape


func place() -> void:
	if placeable and holo and !placed:
		placed = true
		holo = false
		for i in meshes.size():
			meshes[i].set_surface_override_material(0, default_mats[i])
		for mesh in hidden_while_placing:
			mesh.show()

func place_check() -> void:
	if !is_fully_supported():
		set_meshes_material(HOLO_COLLIDING_MATERIAL)
		placeable = false
		return

	var space_state: PhysicsDirectSpaceState3D = boundingbox.get_world_3d().direct_space_state
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	var check_shape: BoxShape3D = box_shape.duplicate_deep()
	check_shape.size -= Vector3(0.01, 0.01, 0.01)

	query.shape = check_shape
	query.transform = boundingbox.global_transform
	query.collision_mask = CollisionLayer.combine(CollisionLayer.TERRAIN, CollisionLayer.STRUCTURE, CollisionLayer.LIVING)
	query.exclude = [body.get_rid()]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var hits: Array[Dictionary] = space_state.intersect_shape(query, 1)
	if hits.size() != 0:
		set_meshes_material(HOLO_COLLIDING_MATERIAL)
		placeable = false
		return
	placeable = true
	set_meshes_material(HOLOGRAM_MATERIAL)

func set_meshes_material(mat: StandardMaterial3D) -> void:
	for i in meshes.size():
		meshes[i].set_surface_override_material(0, mat)

func is_fully_supported() -> bool:
	if !use_foundation:
		return true

	var space_state: PhysicsDirectSpaceState3D = entity.get_world_3d().direct_space_state
	var markers: Array[Marker3D] = foundation.markers
	
	for marker: Marker3D in markers:
		var ray_start: Vector3 = marker.global_position + (entity.global_transform.basis.y * 0.05)
		var ray_end: Vector3 = marker.global_position - (entity.global_transform.basis.y * (support_range + 0.05))
		
		var query := PhysicsRayQueryParameters3D.create(ray_start, ray_end)
		query.collision_mask = CollisionLayer.combine(CollisionLayer.STRUCTURE, CollisionLayer.TERRAIN)
		var result: Dictionary = space_state.intersect_ray(query)
		
		if result.is_empty():
			return false
	return true
