class_name HarvestableResource extends Node3D

enum ResourceType { Diamond, Emerald }

@export var resource_type: ResourceType = ResourceType.Diamond

func harvest(item: Tool) -> void:
	if item.can_harvest(resource_type):
		item.harvest(GlobalItem.item_library["resource"], 5)
