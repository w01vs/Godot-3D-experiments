class_name BuilderComponent extends Component

var structure: Entity

var structures: Array[BuildResource]

var structure_scene: PackedScene
var open: bool = false

func _init_component() -> void:
	InputManager.subscribe(BuildInputEvent, _open_build_menu)

func _open_build_menu(_event: BuildInputEvent) -> void:
	if open:
		ContextManager.push_player_state(PlayerContext.State.BUILDING)
		print_debug("open build menu")
	else:
		ContextManager.pop_player_state()
	open = !open

func set_structure(id: int) -> void:
	pass

#func load_structures() -> void:
	#structures = ResourceManager.load("res://features/building/resources/items/")
