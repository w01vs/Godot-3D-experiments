class_name SimpleEnemy extends CharacterBody3D

@export var eye: Node3D
@export var max_view_distance: float
@export var eye_angle: float
@export var SPEED: float
@export var nav_agent: NavigationAgent3D

var sight_changed: bool = false
var pathfinding: bool = false

var eye_rad: float
var cos_angle: float
var sight_box: Area3D

@onready var health_component: HealthComponent = $HealthComponent
#@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent

func _ready() -> void:
	health_component.died.connect(die)
	var attack: OnHitInformation = OnHitInformation.new()
	#hitbox.set_info(attack)
	calculate_sight_box()

func die() -> void:
	queue_free()

func calculate_sight_box() -> void:
	eye_rad = deg_to_rad(eye_angle)
	cos_angle = cos(eye_rad)
	var has_sight_box: bool = has_node("SightBox")
	var box_shape: CollisionPolygon3D
	if not has_sight_box:
		sight_box = Area3D.new()
		sight_box.name = "SightBox"
		add_child(sight_box)
		box_shape = CollisionPolygon3D.new()
		sight_box.add_child(box_shape)
	else:
		sight_box = get_node("SightBox")
		box_shape = sight_box.get_node("CollisionPolygon3D")
		box_shape.polygon.clear()
	
	var edge: float = max_view_distance * tan(eye_rad)
	var polygons: PackedVector2Array = [Vector2(0,0), Vector2(max_view_distance, edge), Vector2(max_view_distance, -edge)]
	box_shape.polygon = polygons
	box_shape.rotate_y(deg_to_rad(90))
	box_shape.rotate_z(deg_to_rad(90))
	sight_box.owner = self
	box_shape.owner = sight_box
	
	#sight_box.connect("body_exited", exit)
	sight_box.body_exited.connect(exit)

func exit(body: Node3D) -> void:
	velocity = Vector3.ZERO
