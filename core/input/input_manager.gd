extends Node

var event_bus: EventBusBase = EventBusBase.new()

var movement_vector: Vector2
@export var inputs: Array[InputAction]

func _ready() -> void:
	event_bus.enable()
	event_bus.release_events()
	load_input_actions()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func load_input_actions() -> void:
	var path: StringName = "res://core/input/resources/"
	var dir: DirAccess = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path: String = path + file_name
			var resource: Resource = load(full_path)
			if resource is InputAction:
				inputs.append(resource)
				if !resource.debug:
					resource.event_script = resource.event.get_script()
					resource.event = null
		file_name = dir.get_next()

func _physics_process(_delta: float) -> void:
	if ContextManager.is_player_state(PlayerContext.State.GAMEPLAY) \
	and ContextManager.is_game_state(GameContext.State.IN_WORLD):
		movement_vector = Input.get_vector("left", "right", "forward", "backward")
	else:
		movement_vector = Vector2.ZERO

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.use_accumulated_input:
		handle_event(event)
		get_viewport().set_input_as_handled()

func handle_event(event: InputEvent) -> void:
	var game_flag: bool = false
	var player_flag: bool = false
	for action in inputs:
		if event.is_action_pressed(action.name):
			if action.debug:
				handle_debug_input(action)
				return
			for state in action.game_requirements:
				if ContextManager.is_game_state(state):
					game_flag = true
					break
			for state in action.player_requirements:
				if ContextManager.is_player_state(state):
					player_flag = true
					break
			if player_flag and game_flag:
				var input_event: CustomInputEvent = action.event_script.new(self)
				event_bus.raise(input_event)

func handle_debug_input(action: InputAction) -> void:
	if action.name == "lose_focus" and OS.is_debug_build() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		ContextManager.push_game_state(GameContext.State.UNFOCUSED)
	elif action.name == "refocus" and OS.is_debug_build() and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		ContextManager.pop_game_state()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and ContextManager.is_game_state(GameContext.State.IN_WORLD):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			event_bus.raise(MouseMotionInputEvent.new(self, event.relative, event.screen_relative))
		get_viewport().set_input_as_handled()

func enable() -> void:
	event_bus.enable()

func disable() -> void:
	event_bus.disable()

func subscribe(event_type: Script, callback: Callable) -> void:
	assert(event_bus.is_valid_event(event_type, CustomInputEvent))
	if !event_bus.is_valid_event(event_type, CustomInputEvent):
		push_error("Event %s is not a valid entity event" % [ event_type.get_global_name() ])
		return
	event_bus.subscribe(event_type, callback)

func get_movement_vector() -> Vector2:
	return movement_vector
