extends Node3D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent
@onready var nav_agent = $CharacterBody3D/NavigationAgent3D
@onready var body = $CharacterBody3D

@export var player_path: NodePath

var player
var pathfind: bool = true

var SPEED: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.died.connect(die)
	var attack = OnHitInformation.new()
	hitbox.set_info(attack)
	player = get_node(player_path)
	

func _physics_process(delta: float) -> void:
	pathfind = false
	if pathfind:
		body.velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		body.velocity = (next_nav_point - body.global_position).normalized() * SPEED
		#body.velocity.y = 0
		print_debug(next_nav_point)
		print_debug(player.global_position)
		body.move_and_slide()
	if body.global_position.distance_to(player.global_position) < 1:
		pathfind = false
		body.velocity = Vector3.ZERO
	else:
		pathfind = true
		global_position = body.global_position

func die() -> void:
	queue_free()
