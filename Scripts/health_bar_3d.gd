extends Node3D

@export var health_component: HealthComponent
@onready var health_bar: ProgressBar = $SubViewport/HealthBar
var health: float

func _ready():
	health_component.health_changed.connect(healthChanged)
	health = health_component.get_max_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health / health_component.get_max_health()

func healthChanged(amount: float) -> void:
	health = amount
