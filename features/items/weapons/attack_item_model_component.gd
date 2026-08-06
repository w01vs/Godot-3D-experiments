class_name AttackItemModelComponent extends ItemModelComponent

@export var hitbox: HitboxComponent
@export var hitinfo: DamageInfo

func _init_component() -> void:
	assert(hitbox != null)
	assert(hitinfo != null)

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			hitbox.set_monitoring(true)

func on_animation_start(_name: StringName) -> void:
	pass

func on_animation_end(_name: StringName) -> void:
	hitbox.set_monitoring(false)
