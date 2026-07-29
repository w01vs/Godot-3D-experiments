class_name Pickaxe extends Node3D

@onready var hitbox: HitboxComponent = $HitboxComponent
var hitinfo: WeaponData = preload("res://features/items/sword/sword.tres")

func _ready() -> void:
	hitbox.set_info(hitinfo.hit_info)

func use(animator: AnimationPlayer, _player: Player) -> void:
	animator.play(_get_animation())

func on_equip() -> void:
	hitbox.set_info(hitinfo.hit_info)

func on_animation_trigger(event: String) -> void:
	match event:
		"hitbox_on":
			hitbox.monitoring = true

func on_animation_start() -> void:
	pass

func on_animation_end() -> void:
	hitbox.monitoring = false

func _get_animation() -> String:
	return "slash_attack"

func can_harvest(_resource_type: HarvestableComponent.ResourceType) -> bool:
	#if harvestable.find(resource_type) != -1:
		#return true
	return false

func harvest(_itemdata: ItemData, _amount: int) -> void:
	#resource_harvested.emit(itemdata, amount)
	pass
