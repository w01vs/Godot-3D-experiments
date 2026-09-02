extends Node

class CacheEntry:
	var scene: PackedScene
	## Timestamp of last use in milliseconds
	var last_used: int
	var ttl: int = -1
	func _init(scene_: PackedScene) -> void:
		scene = scene_
		touch()
	
	func touch() -> void:
		last_used = Time.get_ticks_msec()
	
	## Sets the time this cache entry should live for
	func set_ttl(time: int) -> void:
		ttl = time
	
	func instantiate() -> Node:
		return scene.instantiate()

## Main cache for scene resources
var _cache: Dictionary[StringName, CacheEntry]
## Cache for resources that should be kept in cache unless removed
## REMIND: Probably not using this for a looong time?
var _pinned_cache: Dictionary[StringName, PackedScene]

@export var _cache_limit: int = 30
@export var _cache_check: float = 30
@export var _unused_evict_time: int = 180

var _cache_timer: Timer

# Scene managing stuff

func _load_scene(name_: StringName, pin: bool = false) -> void:
	var scene: PackedScene = load(name_)
	if pin:
		_pinned_cache.set(name_, scene)
		return
	if _cache.size() > _cache_limit:
		_c_evict_lru()
	var entry := CacheEntry.new(scene)
	_cache.set(name_, entry)

func unload_scene(name_: StringName) -> void:
	# No .has() since erase does this by default
	_cache.erase(name_)
	_pinned_cache.erase(name_)

func get_scene_instance(name_: StringName) -> Node:
	if _cache.has(name_):
		return _cache.get(name_).instantiate()
	elif _pinned_cache.has(name_):
		return _pinned_cache.get(name_).instantiate()
	_load_scene(name_)
	return _cache.get(name_).instantiate()

# Cache stuff -------------------------------------

func _ready() -> void:
	_cache_timer = Timer.new()
	_cache_timer.wait_time = _cache_check
	_cache_timer.autostart = true
	_cache_timer.timeout.connect(_c_garbage_collect)
	add_child(_cache_timer)

func _c_evict_lru() -> void:
	var oldest_key: StringName = &""
	var oldest_time: int = -1
	
	for path in _cache:
		var entry: CacheEntry = _cache[path]
		if entry.last_used < oldest_time:
			oldest_key = path
	
	if !oldest_key.is_empty():
		_cache.erase(oldest_key)

func _c_garbage_collect() -> void:
	var time: int = Time.get_ticks_msec()
	var ttl_msec: int = int(_unused_evict_time * 1000)
	var to_evict: Array[StringName] = []
	for path in _cache:
		var entry: CacheEntry = _cache[path]
		if(time - entry.last_used) > ttl_msec:
			to_evict.append(entry)
	for path in to_evict:
		_cache.erase(path)
