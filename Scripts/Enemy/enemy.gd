extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent
#@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent

var SPEED: float = 5

@export var eye: Node3D
var start: Vector3
var direction: Vector3
@export var eye_angle: float
var eye_rad: float
@export var max_view_distance: float
var cos_angle: float
var sight_box: Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.died.connect(die)
	var attack = OnHitInformation.new()
	#hitbox.set_info(attack)
	calculate_sight_box()

func die() -> void:
	queue_free()

# GDQuest video
# move to PlayerInViewBT
func sight() -> void:
	if sight_box == null:
		var ray: RayCast3D = RayCast3D.new()
		# cast to player
		# probe width of player
		# maybe probe height as well?
		# check what it hits
		# if player, true
		# false


func calculate_sight_box() -> void:
	direction = (-transform.basis.z).normalized()
	start = eye.global_position
	eye_rad = deg_to_rad(eye_angle)
	cos_angle = cos(eye_rad)
	sight_box = get_node("SightBox")
	var box_shape: CollisionPolygon3D
	if sight_box == null:
		sight_box = Area3D.new()
		sight_box.name = "SightBox"
		add_child(sight_box)
		box_shape = CollisionPolygon3D.new()
		sight_box.add_child(box_shape)
	else:
		box_shape = sight_box.get_node("CollisionPolygon3D")
		box_shape.polygon.clear()
	
	var edge: float = max_view_distance * tan(eye_rad)
	var polygons: PackedVector2Array = [Vector2(0,0), Vector2(max_view_distance, edge), Vector2(max_view_distance, -edge)]
	box_shape.polygon.append_array(polygons)
	
