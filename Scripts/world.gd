extends Node3D
class_name World

@onready var player_healthbar: BetterHealthBar = $CanvasLayer/BetterHealthBar
@onready var player: Player = $BetterPlayer
var player_health_component: HealthComponent
var player_health: float

func _ready() -> void:
	player_health_component = player.get_node("HealthComponent")
	player_health_component.health_changed.connect(updateHealth)
	player_health = player_health_component.get_max_health()

func _process(delta: float) -> void:
	player_healthbar.value = player_health / player_health_component.get_max_health()

func updateHealth(amount: float) -> void:
	player_health = amount
