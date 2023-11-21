extends Node3D

@export var health_component: HealthComponent
var health: float
@onready var health_bar: ProgressBar = $SubViewport/HealthBar
func _ready():
	health_component.health_changed.connect(healthChanged)
	health = health_component.get_max_health()

func _process(delta):
	health_bar.value = health / health_component.get_max_health()

func healthChanged(amount: float) -> void:
	health = amount
