class_name Sword extends Item

var info: OnHitInformation

@onready var hitbox: HitboxComponent = $HitboxComponent
var hitinfo: OnHitInformation = preload("res://Resources/ItemInfo/sword.tres")

func _ready():
	hitbox.set_info(hitinfo)

func use() -> void:
	pass
