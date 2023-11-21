extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(4, true)
