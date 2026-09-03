class_name HarvestableComponent extends Component

@export var item: ResourceData
@export var quantity: int
@export var body: CStaticBody3D
@export var mesh: MeshInstance3D
var ring: PackedVector3Array = []
var right_left_offset: float = 0.5
var front_back_offset: Vector2 = Vector2(-0.2, 0.3)

var inverse_xform: Transform3D

func _init_component() -> void:
	subscribe(CollisionEnteredEntityEvent, _harvest)
	_initialise_body()
	assert(item)
	assert(quantity > 0)
	inverse_xform = entity.global_transform.affine_inverse()

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	if mesh.has_meta("ring"):
		ring = mesh.get_meta("ring")
		mesh.remove_meta("ring")

func _harvest(event: CollisionEntityEvent) -> void:
	if event.data is CollisionData:
		emit(DropItemEvent.new(self, item, quantity, get_terrain_drop_point(event.data.source.global_position)))

func _initialise_body() -> void:
	body.cset_collision_layer_value(CollisionLayer.HARVESTABLE, true)

func get_terrain_drop_point(player_pos: Vector3) -> Vector3:
	var ring_point := get_drop_position(player_pos)
	var space_state := body.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		ring_point + Vector3.UP * 5.0,
		ring_point + Vector3.DOWN * 10.0
	)
	query.collision_mask = CollisionLayer.combine(CollisionLayer.STRUCTURE, CollisionLayer.TERRAIN)
	var result := space_state.intersect_ray(query)
	
	return result.position if result else ring_point

func get_drop_position(point: Vector3) -> Vector3:
	var point_count := ring.size()
	if point_count < 2:
		return point
		
	var point_local := inverse_xform * point
	var player_2d := Vector2(point_local.x, point_local.z)
	var center_2d := Vector2.ZERO # Rock local origin
	
	# Ray line from player directly toward rock center
	var ray_p1 := player_2d
	var ray_p2 := center_2d
	
	var best_intersection := Vector2.ZERO
	var found_intersection := false
	var min_dist_to_player := INF
	
	# 1. Find the intersection point on the ring along the player-to-rock ray
	for i in range(point_count):
		var seg_p1 := Vector2(ring[i].x, ring[i].z)
		var seg_p2 := Vector2(ring[(i + 1) % point_count].x, ring[(i + 1) % point_count].z)
		var hit: Variant = Geometry2D.segment_intersects_segment(ray_p1, ray_p2, seg_p1, seg_p2)
		if hit != null:
			var dist := player_2d.distance_to(hit)
			if dist < min_dist_to_player:
				min_dist_to_player = dist
				best_intersection = hit
				found_intersection = true

	var base_drop_2d := best_intersection if found_intersection else player_2d
	
	var ray_dir := (center_2d - player_2d).normalized() if player_2d.length_squared() > 0.0001 else Vector2.UP
	
	var perp_dir := Vector2(-ray_dir.y, ray_dir.x)
	
	var radial_shift := ray_dir * randf_range(-right_left_offset, right_left_offset)
	var perp_shift := perp_dir * randf_range(front_back_offset.x, front_back_offset.y)
	
	var final_drop_2d := base_drop_2d + radial_shift + perp_shift
	
	var local_drop := Vector3(final_drop_2d.x, ring[0].y, final_drop_2d.y)
	return entity.global_transform * local_drop
