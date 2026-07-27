class_name Set extends Resource

var map: Dictionary
const VALUE: bool = true
var start: int
var current: int

func _init() -> void:
	map = Dictionary()
	self.start = 0
	self.current = 0

func add(element: Variant) -> void:
	map[element] = VALUE

func add_all(elements: Variant) -> void:
	for e: Variant in elements:
		add(e)

func remove(element: Variant) -> void:
	map.erase(element)

func clear() -> void:
	map.clear()

func contains(element: Variant) -> bool:
	return map.has(element)

func is_empty() -> bool:
	return map.is_empty()

func size() -> int:
	return map.size()

func should_continue() -> bool:
	return (current < self.size())

func _iter_init(_arg: Array) -> bool:
	current = start
	return should_continue()

func _iter_next(_arg: Array) -> bool:
	current += 1
	return should_continue()

func _iter_get(_arg: Variant) -> Variant:
	return map.keys()[current]
