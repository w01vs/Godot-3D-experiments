class_name BuilderComponent extends Component

var structure: Entity
var world: World

var structures: Array[BuildResource]

var structure_scene: PackedScene
var open: bool = false

var bindings: BuildBindings = BuildBindings.new(set_structure)

func _init_component() -> void:
	load_structures()
	InputManager.subscribe(BuildInputEvent, _open_build_menu)
	entity.raise_global(BuildComponentReadyEvent.new(self, bindings, _get_ui_data()))

func set_world(event: WorldLoadedEvent) -> void:
	world = event.source

func _open_build_menu(_event: BuildInputEvent) -> void:
	if !open:
		ContextManager.push_player_state(PlayerContext.State.BUILDING)
		entity.raise_global(BuildMenuOpenEvent.new(self))
		print_debug("open build menu")
	else:
		ContextManager.pop_player_state()
		entity.raise_global(BuildMenuCloseEvent.new(self))
	open = !open

func set_structure(id: int) -> void:
	structure = structures[id].scene.instantiate()
	world.add_child(structure)

func load_structures() -> void:
	structures = ResourceManager.load_structures("res://features/building/resources/items/")

func _get_ui_data() -> Array[UIBuildItemView]:
	var res: Array[UIBuildItemView] = []
	for struc in structures:
		res.append(UIBuildItemView.new(struc.name, struc.icon, struc.group, struc.id))
	return res
