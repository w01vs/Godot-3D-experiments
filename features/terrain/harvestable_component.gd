class_name HarvestableComponent extends Component

enum ResourceType { Diamond, Emerald }

@export var hurtbox: HurtboxComponent
@export var resource_type: ResourceType = ResourceType.Diamond

func _init_component() -> void:
	subscribe(DamageEntityEvent, _harvest, EventBase.Priority.PRE)

func _harvest(event: DamageEntityEvent) -> void:
	event.damage_info
	event.damage_source
