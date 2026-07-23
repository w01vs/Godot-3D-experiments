@abstract class_name Tool extends Item

signal resource_harvested(type: ItemData, amount: int)

@export var harvestable: Array[HarvestableResource.ResourceType]

@abstract func can_harvest(resource_type: HarvestableResource.ResourceType) -> bool
@abstract func harvest(itemdata: ItemData, amount: int) -> void
