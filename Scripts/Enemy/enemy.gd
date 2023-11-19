extends CharacterBody3D

@onready var health_component: HealthComponent = $HealthComponent
#@onready var hitbox: HitboxComponent = $CharacterBody3D/sword/HitboxComponent

var SPEED: float = 5
var x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.died.connect(die)
	var attack = OnHitInformation.new()
	#hitbox.set_info(attack)

func die() -> void:
	queue_free()
