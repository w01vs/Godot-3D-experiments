class_name EventBus

var _listeners: Dictionary

func subscribe(event_type: Script, callback: Callable, priority: Event.Priority) -> void:
	if not _listeners.has(event_type):
		_listeners[event_type][priority] = []
	if not _listeners[event_type][priority].has(callback):
		_listeners[event_type][priority].append(callback)

func unsubscribe(event_type: Script, callback: Callable) -> void:
	for prio: Event.Priority in _listeners[event_type]:
		var callbacks: Array[Callable] = _listeners[event_type][prio]
		for i in range(_listeners[event_type][prio].size()):
			var cb: Callable = _listeners[event_type].get(prio)
			if cb == callback:
				callbacks[i] = callbacks[callbacks.size() - 1]
				callbacks.pop_back()

func raise(event: Event) -> void:
	var event_type: Script = event.get_script()
	if _listeners.has(event_type):
		var callbacks: Array[Callable] = _listeners.get(event_type)
		for i in range(callbacks.size()):
			var callback: Callable = callbacks.get(i)
			if callback.is_valid():
				callback.call(event)
			else:
				callbacks[i] = callbacks[callbacks.size() - 1]
				callbacks.pop_back()
