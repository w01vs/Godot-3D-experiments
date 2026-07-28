class_name EventBusBase

var _listeners: Dictionary[Script, Dictionary]

var active: bool = true
var hold: bool = true

var dispatch_held: Array[EventBase] = []


func subscribe(event_type: Script, callback: Callable, priority: EventBase.Priority = EventBase.Priority.BASE) -> void:
	if not _listeners.has(event_type):
		_listeners[event_type] = {}
		_listeners[event_type][priority] = []
	if not _listeners[event_type][priority].has(callback):
		_listeners[event_type][priority].append(callback)

func unsubscribe(event_type: Script, callback: Callable) -> void:
	if _listeners.has(event_type):
		for prio: Event.Priority in _listeners[event_type]:
			var callbacks: Array = _listeners[event_type][prio]
			for i in range(_listeners[event_type][prio].size()):
				var cb: Callable = _listeners[event_type].get(prio)
				if cb == callback:
					callbacks[i] = callbacks[callbacks.size() - 1]
					callbacks.pop_back()

func raise(event: EventBase) -> void:
	if !active: 
		return
	if hold: 
		dispatch_held.append(event)
		return
	var event_type: Script = event.get_script()
	if _listeners.has(event_type):
		for prio: EventBase.Priority in [EventBase.Priority.PRE, EventBase.Priority.BASE, EventBase.Priority.POST]:
			if _listeners.get(event_type).get(prio):
				var callbacks: Array = _listeners.get(event_type).get(prio)
				for i: int in range(callbacks.size()):
					var callback: Callable = callbacks.get(i)
					if callback.is_valid():
						callback.call(event)
					else:
						callbacks[i] = callbacks[callbacks.size() - 1]
						callbacks.pop_back()

func _raise_held() -> void:
	for event: EntityEvent in dispatch_held:
		raise(event)
	dispatch_held.clear()

func enable() -> void:
	active = true

func disable() -> void:
	active = false

func hold_events() -> void:
	hold = true

func release_events() -> void:
	hold = false
	_raise_held()

func is_valid_event(event: Script, valid_event: Script) -> bool:
	if event.get_base_script() == valid_event:
		return true
	var current_script: Script = event
	while current_script != valid_event:
		current_script = current_script.get_base_script()
		if current_script == valid_event:
			return true
	return false