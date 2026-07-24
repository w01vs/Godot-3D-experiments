class_name HarvestableComponent extends Component

enum ResourceType { Diamond, Emerald }

@export var resource_type: ResourceType = ResourceType.Diamond

func _init_component() -> void:
	type = ComponentType.HARVESTABLE
