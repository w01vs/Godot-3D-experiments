extends Node3D

@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	health_component.died.connect(die)

func die() -> void:
	queue_free()
