class_name HitboxComponent extends Area3D

var on_hit_information: OnHitInformation

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(3, true)
	connect("area_entered", _on_area_entered)

func set_info(info: OnHitInformation) -> void:
	on_hit_information = info

func _on_area_entered(area: Area3D):
	if area is HurtboxComponent:
		UniversalHitController.apply_information_to(on_hit_information, area.get_parent())
