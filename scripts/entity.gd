class_name Entity extends Node3D

var components: Dictionary[Script, Component] = {}

signal loaded()

var _local_listeners: Dictionary
var _global_subscriptions: Array[Script]

var active: bool = true
var loading: bool = true

var dispatch_loading: Array[EntityEvent] = []

func _ready() -> void:
	loading = false
	on_load()
	loaded.emit()

func register(component: Component) -> void:
	for s in find_bases(component.get_script(), true):
		components.set(s, component)

func get_component(script: Script) -> Component:
	return components.get(script)

func has_component(script: Script) -> bool:
	return components.has(script)

func remove_component(component: Component) -> void:
	for s in find_bases(component.get_script(), true):
		if get_component(s) == component:
			components.erase(component)
	pass

func find_bases(script: Script, removing: bool) -> Array[Script]:
	var current_script: Script = script
	var scripts: Array[Script] = []
	while current_script != Component:
		assert(!components.has(current_script) || removing)
		if components.has(current_script):
			push_error("A component of this type %s has already been registered" % [ current_script.get_global_name() ])
			return []
		scripts.append(current_script)
		current_script = current_script.get_base_script()
	return scripts

func subscribe_local(event_type: Script, callback: Callable) -> void:
	if not _local_listeners.has(event_type):
		_local_listeners[event_type] = []
	if not _local_listeners[event_type].has(callback):
		_local_listeners[event_type].append(callback)

func raise_local(event: EntityEvent) -> void:
	if !active:
		return
	if loading:
		dispatch_loading.append(event)
		return
	var event_type: Script = event.get_script()
	if _local_listeners.has(event_type):
		var callbacks: Array[Callable] = _local_listeners.get(event_type)
		for i in range(callbacks.size()):
			var callback: Callable = callbacks.get(i)
			if callback.is_valid():
				callback.call(event)
			else:
				callbacks[i] = callbacks[callbacks.size() - 1]
				callbacks.pop_back()

func on_load() -> void:
	for event: EntityEvent in dispatch_loading:
		raise_local(event)
	dispatch_loading.clear()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for comp: Component in components.values():
			comp.queue_free()

func enable() -> void:
	show()

func disable() -> void:
	hide()
