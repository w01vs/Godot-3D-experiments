extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var apply_damage_multiplier: bool

signal hit_by_hitbox(hitbox: Area3D)

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(hitbox: Area3D) -> void:
	if hitbox is HitboxComponent:
		UniversalHitController.apply_information_to(hitbox.on_hit_information, get_parent())
