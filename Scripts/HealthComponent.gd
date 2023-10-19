extends Node
class_name HealthComponent

var health: float
var max_health: float = 100

signal health_changed(float)
signal died()

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	clamp_health()
	health_0()

func decrease_health(amount: int) -> void:
	if health > 0:
		health -= amount
		clamp_health()
		health_changed.emit(health)

func increase_health(amount: int) -> void:
	if health < max_health:
		health += amount
		clamp_health()
		health_changed.emit(health)

func health_0() -> void:
	if health <= 0:
		died.emit()

func clamp_health() -> void:
	health = clamp(health, 0, max_health)
	
func set_max_health(amount: float) -> void:
	max_health = amount
	
func get_max_health() -> float:
	return max_health
