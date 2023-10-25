extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent
#@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var world: Node3D
@export var x: int = 100

var player

var pathfind: bool = true
var SPEED: float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.died.connect(die)
	var attack = OnHitInformation.new()
	#hitbox.set_info(attack)
	player = get_node(get_meta("player_path"))
	world = get_tree().current_scene

func _process(delta: float) -> void:
	update_target(player.global_position)

func _physics_process(delta: float) -> void:
	if pathfind:
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - global_transform.origin).normalized() * SPEED
		
		velocity = velocity.move_toward(new_velocity, 0.25)
	
	if global_position.distance_to(player.global_position) < 1.5:
		velocity = Vector3.ZERO
		pathfind = false
	else: 
		pathfind = true
	move_and_slide()

func update_target(target: Vector3) -> void:
	nav_agent.target_position = target
	

func die() -> void:
	queue_free()


func _on_navigation_agent_3d_target_reached():
	#velocity = Vector3.ZERO
	pass
