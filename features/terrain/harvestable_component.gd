class_name HarvestableComponent extends Component

@export var item: ResourceData
@export var quantity: int
@export var body: CStaticBody3D
@export var mesh: MeshInstance3D
var ring: PackedVector3Array = []

func _init_component() -> void:
	subscribe(CollisionEntityEvent, _harvest)
	_initialise_body()
	assert(item)
	assert(quantity > 0)

func _on_entity_load(_event: EntityLoadedEvent) -> void:
	if mesh.has_meta("ring"):
		ring = mesh.get_meta("ring")
		mesh.remove_meta("ring")

func _harvest(event: CollisionEntityEvent) -> void:
	if event.data is CollisionData:
		entity.raise_global(DropItemEvent.new(self, item, quantity, entity.global_position))

func _initialise_body() -> void:
	body.cset_collision_layer_value(CollisionLayer.HARVESTABLE, true)
