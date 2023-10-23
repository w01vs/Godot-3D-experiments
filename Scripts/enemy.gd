extends Node3D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent
@onready var nav_agent = $CharacterBody3D/NavigationAgent3D
@onready var body = $CharacterBody3D

@export var player_path: NodePath

var player
var pathfind: bool = true

var SPEED: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.died.connect(die)
	var attack = OnHitInformation.new()
	hitbox.set_info(attack)
	player = get_node(player_path)
	

func _process(delta: float) -> void:
	if pathfind:
		body.velocity = Vector3.ZERO
		var temp = player.global_position
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		body.velocity = -(next_nav_point - player.global_position).normalized() * SPEED
		body.velocity.y = 0
		body.move_and_slide()
	if body.global_position.distance_to(player.global_position) < 0.5:
		pathfind = false
	else:
		pathfind = true

func die() -> void:
	queue_free()
