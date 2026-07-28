extends CanvasLayer

var player_health_component: HealthComponent
var player_health: float
var player: Player

@onready var player_healthbar: PlayerHealthBar = $BetterHealthBar

func _ready() -> void:
	EventBus.subscribe(PlayerLoadedEvent, get_player_entity)

func _process(_delta: float) -> void:
	#player_healthbar.value = player_health / player_health_component.get_max_health()
	pass

func updateHealth(amount: float) -> void:
	player_healthbar.value = amount / player_health_component.get_max_health()

func get_player_entity(event: PlayerLoadedEvent) -> void:
	player = event.source
	initialise_healthbar()

func initialise_healthbar() -> void:
	player_health_component = player.player_entity.get_component(HealthComponent)
	player_health_component.health_changed.connect(updateHealth)
	player_health = player_health_component.get_max_health()
