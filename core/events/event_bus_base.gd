class_name EventBusBase

var listeners_: Dictionary[Script, Dictionary]

var active: bool = true
var hold: bool = true

var dispatch_held: Array[EventBase] = []

class Subscriber:
	var callback: Callable
	var conditions: Callable
	var object: Object
	func _init(callback_: Callable, conditions_: Callable) -> void:
		callback = callback_
		conditions = conditions_
		object = callback.get_object()


func subscribe(event_type: Script, callback: Callable, conditions: Callable,  priority: EventBase.Priority = EventBase.Priority.BASE) -> void:
	if not listeners_.has(event_type):
		listeners_[event_type] = {}
		for prio: EventBase.Priority in [EventBase.Priority.PRE, EventBase.Priority.BASE, EventBase.Priority.POST]:
			var arr: Array[Subscriber] = []
			listeners_[event_type].set(prio, arr)
	var sub: Subscriber = Subscriber.new(callback, conditions)
	if not has_callback(listeners_[event_type][priority], callback):
		listeners_[event_type][priority].append(sub)

func unsubscribe(event_type: Script, callback: Callable) -> void:
	if listeners_.has(event_type):
		for prio: Event.Priority in listeners_[event_type]:
			var subscribers: Array = listeners_[event_type][prio]
			for i in range(listeners_[event_type][prio].size()):
				var cb: Callable = listeners_[event_type][prio][i].callback
				if cb == callback || !cb.is_valid():
					subscribers[i] = subscribers[subscribers.size() - 1]
					subscribers.pop_back()
					
					

func emit(event: EventBase) -> void:
	if !active: 
		return
	if hold: 
		dispatch_held.append(event)
		return
	var event_type: Script = event.get_script()
	if listeners_.has(event_type):
		for prio: EventBase.Priority in [EventBase.Priority.PRE, EventBase.Priority.BASE, EventBase.Priority.POST]:
			if listeners_.get(event_type).get(prio):
				var subscribers: Array = listeners_.get(event_type).get(prio)
				for i: int in range(subscribers.size()):
					var callback: Callable = subscribers.get(i).callback
					var condition: Callable = subscribers.get(i).conditions
					if callback.is_valid() and condition.is_valid():
						if condition.call():
							callback.call(event)
					else:
						subscribers[i] = subscribers[subscribers.size() - 1]
						subscribers.pop_back()

func _emit_held() -> void:
	for event: EventBase in dispatch_held:
		emit(event)
	dispatch_held.clear()

func enable() -> void:
	active = true

func disable() -> void:
	active = false

func hold_events() -> void:
	hold = true

func release_events() -> void:
	hold = false
	_emit_held()



func has_callback(array: Array[Subscriber], callback: Callable) -> bool:
	for sub in array:
		if sub.callback == callback:
			return true
	return false
