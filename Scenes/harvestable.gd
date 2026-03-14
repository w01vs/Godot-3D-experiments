class_name HarvestableComponent extends StaticBody3D

var on_hit_information: OnHitInformation

func harvest(harvester: Tool) -> void:
	get_parent().harvest(harvester)
