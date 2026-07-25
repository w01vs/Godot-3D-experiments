class_name AttackItemModelComponent extends ItemModelComponent

@export var hitbox: HitboxComponent
@export var hitinfo: OnHitInformation

func _init_component() -> void:
	super._init_component()
	type = ComponentType.ATTACK
	register(hitbox)
	hitbox.set_info(hitinfo)

func _execute_use(player: Player) -> void:
	pass

func _on_equip(player: Player, itemdata: ItemData) -> void:
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
