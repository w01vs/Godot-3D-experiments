class_name Sword extends Node3D

@onready var hitbox: HitboxComponent = $HitboxComponent
var hitinfo: DamageInfo = preload("res://features/items/sword/sword_hit_info.tres")

func _ready() -> void:
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
