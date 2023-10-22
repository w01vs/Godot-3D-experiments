extends Sprite3D

@export var health_component: HealthComponent
@onready var bar = $SubViewport/health_bar_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $SubViewport.get_texture()
	health_component.health_changed.connect(update_value)

func update_value(amount: float) -> void:
	bar.value = amount / health_component.get_max_health()
	print_debug(amount)
