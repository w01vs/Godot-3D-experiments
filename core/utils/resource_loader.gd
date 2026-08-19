class_name ResourceManager extends RefCounted

static func load(path: StringName, filetype: StringName = "tres") -> Array[Resource]:
	var dir: DirAccess = DirAccess.open(path)
	var resources: Array[Resource]
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with("." + filetype):
			var full_path: String = path + file_name
			var resource: Resource = load(full_path)
			resources.append(resource)
			if !resource.debug:
				resource.event_script = resource.event.get_script()
				resource.event = null
	file_name = dir.get_next()
	return resources
