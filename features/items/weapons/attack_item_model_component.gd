class_name AttackItemModelComponent extends ItemModelComponent

@export var hitbox: HitboxComponent
@export var hitinfo: DamageInfo

func _init_component() -> void:
	assert(hitbox != null)
	assert(hitinfo != null)
	hitbox.set_info(hitinfo)

func _on_equip(_player: Player, itemdata: ItemData) -> void:
	data = itemdata
	hitbox.set_info(hitinfo)

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			hitbox.set_monitoring(true)

func on_animation_start() -> void:
	pass

func on_animation_end() -> void:
	hitbox.set_monitoring(false)
