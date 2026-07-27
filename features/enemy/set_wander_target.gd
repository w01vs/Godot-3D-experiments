extends ActionNodeBT

@export_category("Settings")
@export var wander_radius: int
@export var radius_center: Vector3
@export var actor: SimpleEnemy

func action() -> int:
	var map: RID = GlobalRefs.map
	var synced: int = NavigationServer3D.map_get_iteration_id(map)
	if synced == 0:
		return FAILED
	actor.nav_agent.target_position = await get_new_destination()
	actor.pathfinding = true
	if not actor.nav_agent.is_target_reachable():
		return FAILED
	return SUCCESS

func get_new_destination() -> Vector3:
	var map: RID = GlobalRefs.map
	var u: float = randf_range(0, 1)
	var v: float = randf_range(0, 1)
	var _w: float = randf_range(0, 1)
	var volumeRandom: float = randf_range(0, 1)
	
	var theta: float = PI * 2 * u
	var phi: float = acos(2 * v - 1)
	var r: float = wander_radius * volumeRandom
	
	var x: float = r * sin(phi) * cos(theta)
	var y: float = r * sin(phi) * sin(theta)
	var z: float = r * cos(phi)
	
	var target_position: Vector3 = Vector3(x, y, z)
	
	await get_tree().physics_frame
	var closest_point: Vector3 = NavigationServer3D.map_get_closest_point(map, target_position)
	return closest_point + radius_center
