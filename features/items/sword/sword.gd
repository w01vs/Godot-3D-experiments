class_name Sword extends Item

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
			hitbox.set_monitoring(true)

func on_animation_start() -> void:
	pass

func on_animation_end() -> void:
	hitbox.set_monitoring(false)

func _get_animation() -> String:
	return "slash_attack"
