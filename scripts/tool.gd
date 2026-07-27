@abstract class_name Tool extends Item

signal resource_harvested(type: ItemData, amount: int)

@export var harvestable: Array[HarvestableComponent.ResourceType]

@abstract func can_harvest(resource_type: HarvestableComponent.ResourceType) -> bool
@abstract func harvest(itemdata: ItemData, amount: int) -> void
