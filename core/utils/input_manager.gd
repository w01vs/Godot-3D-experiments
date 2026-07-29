extends Node

var context: Context.State = Context.State.GAMEPLAY

var event_bus: EventBusBase = EventBusBase.new()

func _ready() -> void:
	event_bus.enable()
	event_bus.release_events()

func _physics_process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		event_bus.raise(InteractInputEvent.new(self))
	if Input.is_action_just_pressed("snap"):
		event_bus.raise(SnapInputEvent.new(self))
	if Input.is_action_just_pressed("refocus"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if Input.is_action_just_pressed("build"):
		event_bus.raise(BuildInputEvent.new(self))
	if Input.is_action_just_pressed("jump"):
		event_bus.raise(BuildInputEvent.new(self))
	if Input.is_action_just_pressed("inventory"):
		event_bus.raise(InventoryInputEvent.new(self))
		

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


		
