class_name HarvesterItemModelComponent extends ItemModelComponent

@export var harvester_comp: HarvesterComponent

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			harvester_comp.set_monitoring(true)

func on_animation_start(_name: StringName) -> void:
	pass

func on_animation_end(_name: StringName) -> void:
	harvester_comp.set_monitoring(false)
