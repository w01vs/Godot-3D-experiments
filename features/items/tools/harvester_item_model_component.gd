class_name HarvesterItemModelComponent extends ItemModelComponent

var harvester_comp: HarvesterComponent

func on_animation_trigger(event: StringName = "") -> void:
	match event:
		"hitbox_on":
			harvester_comp.set_monitoring(true)
			Component.new()

func on_animation_start(_name: StringName) -> void:
	pass

func on_animation_end(_name: StringName) -> void:
	harvester_comp.set_monitoring(false)

func _on_entity_load() -> void:
	assert(entity.has_component(HarvesterComponent))
	if entity.has_component(HarvesterComponent):
		harvester_comp = entity.get_component(HarvesterComponent)
