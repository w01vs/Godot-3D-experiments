class_name BuilderComponent extends Component

@export var ray: CRayCast3D

var structure_id: int
var structure: Entity
var placeable_component: PlaceableComponent
var structure_comp: StructureComponent
var world: World
var last_build_position: Vector3 = Vector3.INF

var structures: Array[BuildResource]

var structure_scene: PackedScene
var open: bool = false
var building: bool = false

var bindings: BuildBindings = BuildBindings.new(set_structure)

var snapping: bool = false

func _init_component() -> void:
	load_structures()
	InputManager.subscribe(BuildInputEvent, _open_build_menu)
	entity.raise_global(BuildComponentReadyEvent.new(self, bindings, _get_ui_data()))
	entity.subscribe_global(self, WorldLoadedEvent, set_world)
	InputManager.subscribe(PlaceInputEvent, place)
	InputManager.subscribe(SnapInputEvent, _snap)
	ray.target_position.y = -15
	ray.cset_collision_mask_value(CollisionLayer.TERRAIN, true)
	ray.cset_collision_mask_value(CollisionLayer.STRUCTURE, true)
	ray.set_area_collision(true)
	ray.set_body_collision(true)

func set_world(event: WorldLoadedEvent) -> void:
	world = event.source

func _open_build_menu(_event: BuildInputEvent) -> void:
	if !open:
		ContextManager.push_player_state(PlayerContext.State.BUILDING)
		entity.raise_global(BuildMenuOpenEvent.new(self))
		InputManager.release_mouse()
	else:
		ContextManager.pop_player_state()
		entity.raise_global(BuildMenuCloseEvent.new(self))
		InputManager.capture_mouse()
		building = false
		if structure:
			structure.queue_free()
	open = !open

func set_structure(id: int) -> void:
	structure_id = id
	structure = structures[id].scene.instantiate()
	world.add_child(structure)
	placeable_component = structure.get_component(PlaceableComponent)
	structure_comp = structure.get_component(StructureComponent)
	structure_comp.set_collision(false)
	building = true
	entity.raise_global(BuildMenuCloseEvent.new(self))
	InputManager.capture_mouse()

func load_structures() -> void:
	structures = ResourceManager.load_structures("res://features/building/resources/items/")

func _get_ui_data() -> Array[UIBuildItemView]:
	var res: Array[UIBuildItemView] = []
	for struc in structures:
		res.append(UIBuildItemView.new(struc.name, struc.icon, struc.group, struc.id))
	return res

func _physics_process(_delta: float) -> void:
	if !building: 
		return
	if ray.is_colliding():
		var hit_object: Node3D = ray.current_collider as Node3D
		var hit_point: Vector3 = ray.get_collision_point()
		var hit_normal: Vector3 = ray.get_collision_normal()
		var target_pos: Vector3 = Vector3.ZERO
		structure_comp = structure.get_component(StructureComponent)
		if snapping and (hit_object is CStaticBody3D or hit_object is CArea3D):
			if hit_object.entity.has_component(StructureComponent):
				target_pos = hit_object.entity.global_position + (hit_normal * structure.scale)
		else:
			target_pos = hit_point + (hit_normal * (placeable_component.box_shape.size / 2.0))
		
		if target_pos != last_build_position:
			structure.global_position = target_pos
			last_build_position = target_pos
			placeable_component.place_check()
	else:
		placeable_component.set_meshes_material(placeable_component.HOLO_COLLIDING_MATERIAL)
		structure.global_position = ray.global_transform * (ray.position + ray.target_position) 

func _snap(_event: SnapInputEvent) -> void:
	snapping = !snapping

func place(_event: PlaceInputEvent) -> void:
	placeable_component.place_check()
	if placeable_component.placeable:
		placeable_component.place()
		structure_comp.set_collision(true)
		set_structure(structure_id)
