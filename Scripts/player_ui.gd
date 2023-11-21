extends CanvasLayer

var player_health_component: HealthComponent
var player_health: float
var player: Player

@onready var player_healthbar: BetterHealthBar = $BetterHealthBar

func _ready() -> void:
	GlobalRefs.player_set.connect(initialize_healthbar)

func _process(delta: float) -> void:
	player_healthbar.value = player_health / player_health_component.get_max_health()

func updateHealth(amount: float) -> void:
	player_health = amount

func initialize_healthbar() -> void:
	player = GlobalRefs.player
	player_health_component = player.get_node("HealthComponent")
	player_health_component.health_changed.connect(updateHealth)
	player_health = player_health_component.get_max_health()
