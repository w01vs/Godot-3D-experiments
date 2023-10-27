extends State
class_name EnemyWanderState

@onready var actor: CharacterBody3D = $"../.."
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var timer: Timer = $Timer

@export var wander_radius: float
@export var sphere_center: Vector3

var target_set: bool = false
var waiting: bool = false

func _ready() -> void:
	execute_in_process = false

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
	
	var map: RID = get_world_3d().navigation_map
	var closest_point: Vector3 = NavigationServer3D.map_get_closest_point(map, target_position)
	#var delta = closest_point - target_position
	#var is_on_map = delta.is_zero_approx()
	#if not is_on_map:
	#	closest_point = get_new_destination()
	return closest_point + sphere_center

func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass

func _update(delta: float) -> void:
	if not target_set:
		nav_agent.target_position = get_new_destination()
		target_set = true
	
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - actor.global_position).normalized() * actor.SPEED
	
	if nav_agent.is_target_reached() and not waiting:
		wait_or_move()
	
	actor.velocity = new_velocity
	actor.move_and_slide()
	
func wait_or_move() -> void:
	var chance = randf()
	if chance > 0.5:
		target_set = false
	else:
		timer.start(3)
		waiting = true

func _on_timer_timeout():
	target_set = false
	waiting = false
