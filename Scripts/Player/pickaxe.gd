class_name Pickaxe extends Tool

@onready var hitbox: HitboxComponent = $HitboxComponent
var hitinfo: OnHitInformation = preload("res://Resources/ItemInfo/sword.tres")

func _ready():
	hitbox.set_info(hitinfo)

func use(animator: AnimationPlayer, _player: Player) -> void:
	animator.play(_get_animation())

func on_equip() -> void:
	hitbox.set_info(hitinfo)

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

func can_harvest(resource_type: HarvestableResource.ResourceType) -> bool:
	if resource_type == HarvestableResource.ResourceType.Diamond:
		return true
	return false

func harvest(itemdata: ItemData, amount: int) -> void:
	pass
