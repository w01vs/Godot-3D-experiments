class_name HurtboxComponent extends Component

@export var area: ComponentArea3D

signal hitbox_collided(hitbox: Entity)

func _init_component() -> void:
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	area.set_collision_layer_value(3, true)
	area.set_collision_mask_value(4, true)
	area.hit.connect(hit)
	area.monitoring = false

func hit(hitbox: Entity) -> void:
	hitbox_collided.emit(hitbox)
