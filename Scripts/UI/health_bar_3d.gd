extends Node3D

@export var health_component: HealthComponent
var health: float
@onready var health_bar: ProgressBar = $SubViewport/HealthBar

func _ready():
	assert(health_component != null)
	health_component.health_changed.connect(healthChanged)
	health = health_component.get_max_health()

func _process(_delta: float):
	health_bar.value = health / health_component.get_max_health()

func healthChanged(amount: float) -> void:
	health = amount
