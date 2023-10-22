extends Node3D
class_name Sword

var info: OnHitInformation

@onready var hitbox: HitboxComponent = $HitboxComponent
# Called when the node enters the scene tree for the first time.
func _ready():
	info = OnHitInformation.new()
	info.damage = 15
	info.has_damage_info = true
	info.groups = ["enemy"]
	hitbox.set_info(info) 
