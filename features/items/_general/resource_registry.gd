extends Node

# Items
var _item_dir: String = "res://features/items/"
var _item_lib: Dictionary[String, ItemData] = {}

# Buildings
var _build_dir: String = "res://features/building/resources/items/"
var _build_id: int = 0
var _build_lib: Array[BuildResource]

func _ready() -> void:
	load_resources_recursive(_item_dir, process_itemdef)
	load_resources_recursive(_build_dir, process_builddef)
	print("Loaded ", _item_lib.size(), " items into the library.")

func load_resources_recursive(path: String, process_res: Callable) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				load_resources_recursive(path + file_name + "/", process_res)
			else:
				if file_name.ends_with(".tres"):
					var full_path: String = path + file_name
					var resource: Resource = load(full_path)
					process_res.call(resource)
			file_name = dir.get_next()
	else:
		push_error("Failed to access path: " + path)

func process_itemdef(res: Resource) -> void:
	if res is ItemData:
		var def: ItemData = res as ItemData
		_item_lib.set(def.id, def)

func get_item(id: StringName) -> ItemData:
	return _item_lib.get(id, "")

func process_builddef(res: Resource) -> void:
	if res is BuildResource:
		var def: BuildResource = res as BuildResource
		def.id = _build_id
		_build_id += 1
		_build_lib.append(def)

func get_building(id: int) -> BuildResource:
	return _build_lib[id]

func get_all_buildings() -> Array[BuildResource]:
	return _build_lib
