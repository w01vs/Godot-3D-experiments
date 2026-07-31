extends Node

var context: GameContext = GameContext.new(GameContext.GameState.IN_WORLD, null)

var event_bus: EventBusBase = EventBusBase.new()

var movement_vector: Vector2

func _ready() -> void:
	event_bus.enable()
	event_bus.release_events()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventBus.subscribe(PlayerLoadedEvent, _on_player_loaded, EventBase.Priority.PRE)

func _on_player_loaded(event: PlayerLoadedEvent) -> void:
	context.player_context = event.player_context

func _physics_process(_delta: float) -> void:
	movement_vector = Input.get_vector("left", "right", "forward", "backward")

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.use_accumulated_input and context.state == GameContext.GameState.IN_WORLD:
		if event.is_action_pressed("interact"):
			event_bus.raise(InteractInputEvent.new(self))
		elif event.is_action_pressed("snap"):
			event_bus.raise(SnapInputEvent.new(self))
		elif event.is_action_pressed("ui_cancel") and OS.is_debug_build():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.is_action_pressed("refocus") and OS.is_debug_build():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("build"):
			event_bus.raise(BuildInputEvent.new(self))
		elif event.is_action_pressed("jump"):
			event_bus.raise(JumpInputEvent.new(self))
		elif event.is_action_pressed("inventory"):
			event_bus.raise(InventoryInputEvent.new(self))
		else:
			return
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and context.state == GameContext.GameState.IN_WORLD:
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
