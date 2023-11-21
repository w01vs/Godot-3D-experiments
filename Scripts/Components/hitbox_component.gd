class_name HitboxComponent extends Area3D

var on_hit_information: OnHitInformation

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(3, true)
	
func set_info(info: OnHitInformation) -> void:
	on_hit_information = info
