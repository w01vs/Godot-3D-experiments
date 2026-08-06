class_name HarvesterItemModelComponent extends ItemModelComponent

@export var hitbox: HitboxComponent

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			hitbox.set_monitoring(true)

func on_animation_start(_name: StringName) -> void:
	pass

func on_animation_end(_name: StringName) -> void:
	hitbox.set_monitoring(false)

func harvest() -> void:
	#player.inventory.add_item(GlobalItem.item_library.get("diamond").duplicate(), 1)
	pass
