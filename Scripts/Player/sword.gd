class_name Sword extends Node3D

var info: OnHitInformation

@onready var hitbox: HitboxComponent = $HitboxComponent

func _ready():
	info = OnHitInformation.new()
	info.type = DamageSystem.ChangeType.INSTANT
	info.health_change_total = -10
	info.groups = ["enemy"]
	hitbox.set_info(info) 
