extends Node

var context: Context.State = Context.State.GAMEPLAY

var event_bus: EventBusBase = EventBusBase.new()

func _ready() -> void:
	event_bus.enable()

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		event_bus.raise(InteractInputEvent.new(self))

func enable() -> void:
	event_bus.enable()

func disable() -> void:
	event_bus.disable()

func subscribe(event_type: Script, callback: Callable) -> void:
	assert(event_bus.is_valid_event(event_type, EntityEvent))
	if !event_bus.is_valid_event(event_type, EntityEvent):
		push_error("Event %s is not a valid entity event" % [ event_type.get_global_name() ])
		return
	event_bus.subscribe(event_type, callback)


		
