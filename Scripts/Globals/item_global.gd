extends Node

var item_dir: String = "res://Resources/Items/"
var item_library: Dictionary[String, ItemData] = {}

func _ready() -> void:
	load_resources_recursive(item_dir)
	print("Loaded ", item_library.size(), " items into the library.")

func load_resources_recursive(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				load_resources_recursive(path + file_name + "/")
			else:
				if file_name.ends_with(".tres"):
					var full_path = path + file_name
					var resource = load(full_path)
					if resource is ItemData:
						item_library[resource.id] = resource
			file_name = dir.get_next()
	else:
		push_error("Failed to access path: " + path)
