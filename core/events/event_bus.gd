extends Node

var event_bus: EventBusBase = EventBusBase.new()

func _ready() -> void:
	subscribe(WorldLoadedEvent, _on_world_loaded)

func _on_world_loaded(_event: WorldLoadedEvent) -> void:
	event_bus.enable()
	event_bus.release_events()

func subscribe(event_type: Script, callback: Callable, priority: Event.Priority = Event.Priority.BASE, condition: Callable = func() -> bool: return true) -> void:
	assert(callback.get_object() is not Component)
	assert(event_bus.is_valid_event(event_type, Event))
	if callback.get_object() is Component:
		push_error("You cannot subscribe a component to a global event")
		return
	elif !event_bus.is_valid_event(event_type, Event):
		push_error("Event %s is not a valid event" % [ event_type.get_global_name() ])
		return
	event_bus.subscribe(event_type, callback, condition, priority)

func unsubscribe(event_type: Script, callback: Callable) -> void:
	assert(callback.get_object() is not Component)
	assert(event_bus.is_valid_event(event_type, Event))
	if callback.get_object() is Component:
		push_error("You cannot unsubscribe a component to a global event")
		return
	elif !event_bus.is_valid_event(event_type, Event):
		push_error("Event %s is not a valid event" % [ event_type.get_global_name() ])
		return
	event_bus.unsubscribe(event_type, callback)

func raise(event: Event) -> void:
	if event.source is Component:
		push_error("You cannot raise a global event from a component")
		return
	if event is WorldLoadedEvent:
		event_bus.hold = false
	event_bus.raise(event)

func is_valid_event(script: Script) -> bool:
	if script.get_base_script() == Event:
		return true
	var current_script: Script = script
	while current_script != Event:
		current_script = current_script.get_base_script()
		if current_script == Event:
			return true
	return false
