class_name HurtboxComponent extends Component

@export var area: Area3D

signal hitbox_collided(hitbox: HitboxComponent)

func _init_component() -> void:
	type = ComponentType.HURTBOX
	register(area)
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	area.set_collision_layer_value(3, true)
	area.set_collision_mask_value(4, true)

func hit(hitbox: HitboxComponent) -> void:
	hitbox_collided.emit(hitbox)
