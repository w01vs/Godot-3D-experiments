extends ActionNodeBT

@export_category("Settings")
@export var wander_radius: int
@export var radius_center: Vector3
@export var actor: SimpleEnemy

func action() -> int:
	actor.nav_agent.target_position = await get_new_destination()
	actor.pathfinding = true
	if not actor.nav_agent.is_target_reachable():
		return FAILED
	return SUCCESS

func get_new_destination() -> Vector3:
	var u: float = randf_range(0, 1)
	var v: float = randf_range(0, 1)
	var w: float = randf_range(0, 1)
	var volumeRandom: float = randf_range(0, 1)
	
	var theta: float = PI * 2 * u
	var phi: float = acos(2 * v - 1)
	var r: float = wander_radius * volumeRandom
	
	var x: float = r * sin(phi) * cos(theta)
	var y: float = r * sin(phi) * sin(theta)
	var z: float = r * cos(phi)
	
	var target_position: Vector3 = Vector3(x, y, z)
	
	var map: RID = GlobalRefs.map
	await get_tree().physics_frame
	var closest_point: Vector3 = NavigationServer3D.map_get_closest_point(map, target_position)
	#var delta = closest_point - target_position
	#var is_on_map = delta.is_zero_approx()
	#if not is_on_map:
	#	closest_point = get_new_destination()
	return closest_point + radius_center
