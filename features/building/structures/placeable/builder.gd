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
	entity.subscribe_local(self, RayCastRegisteredEntityEvent, _on_raycast_registered)
	InputManager.subscribe(PlaceInputEvent, place)
	InputManager.subscribe(SnapInputEvent, _snap)

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
	open = !open

func set_structure(id: int) -> void:
	structure_id = id
	structure = structures[id].scene.instantiate()
	world.add_child(structure)
	placeable_component = structure.get_component(PlaceableComponent)

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
		if snapping and hit_object is CArea3D:
			if hit_object.entity.has_component(StructureComponent):
				target_pos = hit_object.entity.global_position + (hit_normal * structure.scale)
		else:
			target_pos = hit_point + (hit_normal * (structure.scale / 2.0))
		
		if target_pos != last_build_position:
			structure.global_position = target_pos
			last_build_position = target_pos
			structure_comp.place_check()
		structure_comp.show()
	else:
		structure_comp.hide()
		
	if Input.is_action_just_pressed("snap"):
		snapping = !snapping
		structure_comp.snapping = snapping

func _snap(_event: SnapInputEvent) -> void:
	snapping = !snapping

func place(_event: PlaceInputEvent) -> void:
	if placeable_component.placeable:
		placeable_component.place()
		structure = structures[structure_id].instantiate()
		world.add_child(structure)
		structure_comp = structure.get_component(StructureComponent)
		last_build_position = Vector3.INF
		placeable_component = structure.get_component(PlaceableComponent)
		placeable_component.place_check()

func _on_raycast_registered(event: RayCastRegisteredEntityEvent) -> void:
	if ray == event.source:
		ray.cset_collision_mask_value(CollisionLayer.STRUCTURE, true)
		ray.cset_collision_mask_value(CollisionLayer.TERRAIN, true)
		ray.set_area_collision(true)
		ray.set_body_collision(true)
