@abstract class_name InteractionComponent extends Component

var area: CollisionObject3D

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_area_registered)
	entity.subscribe_local(AreaEntityEvent, _interact)

## [method _on_area_registered] is required and fires when a collision object is registered.
##[br] Check if the collision object is targeting this type of component before assigning.
@abstract func _on_area_registered(event: CollisionShapeRegisteredEntityEvent) -> void

@abstract func _interact(event: AreaEntityEvent) -> void

static func _get_tags() -> Set:
	var tags: Set = Set.new()
	tags.add(CArea3D)
	tags.add(CStaticBody3D)
	return tags
