class_name HarvesterItemModelComponent extends ItemModelComponent

@export var hitbox: HitboxComponent
var player: Player

func _on_equip(player_: Player, itemdata: ItemData) -> void:
	data = itemdata
	player = player_

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			hitbox.set_monitoring(true)

func on_animation_start() -> void:
	pass

func on_animation_end() -> void:
	hitbox.set_monitoring(false)

func harvest() -> void:
	player.inventory.add_item(GlobalItem.item_library.get("diamond").duplicate(), 1)
