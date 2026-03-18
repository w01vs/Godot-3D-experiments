@abstract class_name Tool extends Item

signal resource_harvested(type: ItemData, amount: int)

@abstract func can_harvest(resource_type: HarvestableResource.ResourceType) -> bool
@abstract func harvest(itemdata: ItemData, amount: int) -> void
