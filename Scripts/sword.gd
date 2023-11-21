class_name Sword extends Node3D

var info: OnHitInformation

@onready var hitbox: HitboxComponent = $HitboxComponent

func _ready():
	info = OnHitInformation.new()
	info.damage = 15
	info.has_damage_info = true
	info.groups = ["enemy"]
	hitbox.set_info(info) 
