class_name ResourceManager extends RefCounted

static func load_structures(path: StringName) -> Array[BuildResource]:
	var dir: DirAccess = DirAccess.open(path)
	var resources: Array[BuildResource]
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	var filetype: StringName = ".tres"
	var id: int = 0
	while file_name != "":
		if file_name.ends_with(filetype):
			var full_path: String = path + file_name
			var resource: BuildResource = load(full_path) as BuildResource
			resource.id = id
			id += 1
			resources.append(resource)
		file_name = dir.get_next()
	return resources
