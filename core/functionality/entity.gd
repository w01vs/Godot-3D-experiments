class_name Entity extends Node3D

var component_map: Dictionary[Script, Component] = {}

var global_subscriptions_: Dictionary[Script, Array] = {}

var event_bus: EventBusBase = EventBusBase.new()

var active: bool = true

func _ready() -> void:
	event_bus.enable()
	event_bus.release_events()
	raise_local(EntityLoadedEvent.new(self))

func register(component: Component) -> void:
	for s in find_bases(component.get_script(), true):
		component_map.set(s, component)

func get_component(script: Script) -> Component:
	return component_map.get(script)

func has_component(script: Script) -> bool:
	return component_map.has(script)

func remove_component(component: Component) -> void:
	for s in find_bases(component.get_script(), true):
		if get_component(s) == component:
			component_map.erase(component.get_script())
	for event: Script in global_subscriptions_.keys():
		var callbacks: Array = global_subscriptions_.get(event)
		for i in range(callbacks.size()):
			var cb: Callable = callbacks.get(i)
			if cb.is_valid():
				if cb.get_object() == component:
					callbacks[i] = callbacks[callbacks.size() - 1]
					callbacks.pop_back()
					if callbacks.size() == 0:
						global_subscriptions_.erase(event)
						EventBus.unsubscribe(event, _callback_internal)
					return

func find_bases(script: Script, removing: bool) -> Array[Script]:
	var current_script: Script = script
	var scripts: Array[Script] = []
	while current_script != Component:
		assert(!component_map.has(current_script) || removing)
		if component_map.has(current_script) && !removing:
			push_error("A component of this type %s has already been registered" % [ current_script.get_global_name() ])
			return []
		scripts.append(current_script)
		current_script = current_script.get_base_script()
	return scripts

func subscribe(component: Component, event_type: Script, callback: Callable, prio: EventBase.Priority = EventBase.Priority.BASE) -> void:
	assert(event_bus.is_valid_event(event_type, EntityEvent))
	if !event_bus.is_valid_event(event_type, EntityEvent):
		push_error("Event %s is not a valid entity event" % [ event_type.get_global_name() ])
		return
	event_bus.subscribe(event_type, callback, component.is_active, prio)

func unsubscribe(event_type: Script, callback: Callable) -> void:
	assert(event_bus.is_valid_event(event_type, EntityEvent))
	if !event_bus.is_valid_event(event_type, EntityEvent):
		push_error("Event %s is not a valid entity event" % [ event_type.get_global_name() ])
	event_bus.unsubscribe(event_type, callback)

func raise_local(event: EntityEvent) -> void:
	if !active:
		return
	event_bus.raise(event)

func subscribe_global(component: Component, event_type: Script, callback: Callable, priority: EventBase.Priority = EventBase.Priority.BASE) -> void:
	if !global_subscriptions_.has(event_type):
		global_subscriptions_[event_type] = []
	if !global_subscriptions_[event_type].has(callback):
		global_subscriptions_[event_type].append(callback)
		EventBus.subscribe(event_type, _callback_internal, priority, component.is_active)

func unsubcribe_global(event_type: Script, callback: Callable) -> void:
	EventBus.unsubscribe(event_type, callback)
	var callbacks: Array = global_subscriptions_.get(event_type)
	for i in range(callbacks.size()):
		var cb: Callable = callbacks.get(i)
		if !cb.is_valid():
			continue
		if cb == callback:
			callbacks[i] = callbacks[callbacks.size() - 1]
			callbacks.pop_back()
			return

func raise_global(event: Event) -> void:
	if !active:
		return
	event.source = self
	EventBus.raise(event)

func _callback_internal(event: EventBase) -> void:
	var event_type: Script = event.get_script()
	if global_subscriptions_.has(event_type):
		var callbacks: Array = global_subscriptions_.get(event_type)
		for i in range(callbacks.size()):
			var callback: Callable = callbacks.get(i)
			if callback.is_valid():
				callback.call(event)
			else:
				callbacks[i] = callbacks[callbacks.size() - 1]
				callbacks.pop_back()

func enable() -> void:
	show()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	event_bus.enable()
	active = true

func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	event_bus.disable()
	active = false
