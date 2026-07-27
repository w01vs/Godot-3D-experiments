class_name HarvestableComponent extends Component

enum ResourceType { Diamond, Emerald }

@export var hurtbox: HurtboxComponent
@export var resource_type: ResourceType = ResourceType.Diamond

func _init_component() -> void:
	hurtbox.hitbox_collided.connect(_on_hit)

func _on_hit(_entity: Entity) -> void:
	if _entity.has_component(HarvesterItemModelComponent):
		var harvester: HarvesterItemModelComponent = _entity.get_component(HarvesterItemModelComponent)
		harvester.harvest()

static func _get_tags() -> Set:
	var tags: Set = Set.new()
	tags.add(CArea3D)
	return tags
