extends Node3D
class_name World

@onready var player_healthbar: BetterHealthBar = $CanvasLayer/BetterHealthBar
@onready var player: Player = $BetterPlayer
var player_health_component: HealthComponent
var player_health: float

signal nav_setup_done()

@onready var nav_region1: NavigationRegion3D = $NavigationRegion3D
var nav_map1: RID

func _ready() -> void:
	player_health_component = player.get_node("HealthComponent")
	player_health_component.health_changed.connect(updateHealth)
	player_health = player_health_component.get_max_health()
	call_deferred("setup_nav_region")

func setup_nav_region() -> void:
	nav_map1 = NavigationServer3D.map_create()
	NavigationServer3D.map_set_up(nav_map1, Vector3.UP)
	NavigationServer3D.map_set_active(nav_map1, true)
	
	var region: RID = NavigationServer3D.region_create()
	NavigationServer3D.region_set_transform(region, transform)
	NavigationServer3D.region_set_map(region, nav_map1)
	
	var navigation_mesh: NavigationMesh = nav_region1.navigation_mesh
	NavigationServer3D.region_set_navigation_mesh(region, navigation_mesh)
	
	NavigationServer3D.set_debug_enabled(true)
	
	await get_tree().physics_frame
	
	nav_setup_done.emit()
	
	

func find_path(start: Vector3, target: Vector3) -> PackedVector3Array:
	return NavigationServer3D.map_get_path(nav_map1, start, target, true)

func _process(delta: float) -> void:
	player_healthbar.value = player_health / player_health_component.get_max_health()

func updateHealth(amount: float) -> void:
	player_health = amount
