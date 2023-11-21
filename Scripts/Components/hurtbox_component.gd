extends Area3D
class_name HurtboxComponent

signal hit_by_hitbox(hitbox: Area3D)

@export var health_component: HealthComponent

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(4, true)
	area_entered.connect(on_area_entered)

func on_area_entered(hitbox: Area3D) -> void:
	if hitbox is HitboxComponent:
		UniversalHitController.apply_information_to(hitbox.on_hit_information, get_parent())
