@tool
extends Node

func get_target_components_property(tag: Script) -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var options: String = get_components_with_tag(tag)
	properties.append({
		"name": "target_components",
		"type": TYPE_ARRAY,
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, options]
	})
	
	return properties

func get_components_with_tag(tag: Script) -> String:
	var non_abstract_classes: Array[String] = get_derived_component_classes(tag)
	var string_enum_pairs: Array[String] = []
	for cls in non_abstract_classes:
		string_enum_pairs.append("%s:%s" % [cls, cls])
	
	var enum_hint_string: String = ",".join(non_abstract_classes)
	return enum_hint_string

func get_derived_component_classes(required: Script) -> Array[String]:
	var result: Array[String] = []
	var global_classes: Array[Dictionary] = ProjectSettings.get_global_class_list()
	
	for class_info in global_classes:
		var script_path: String = class_info.path
		if inherits_from(script_path, "res://core/components/component.gd"):
			var script_res: GDScript = load(script_path) as GDScript
			if script_res and not script_res.is_abstract():
				var tags: Set = script_res._get_tags()
				if tags.contains(required):
					result.append(class_info.class)
	return result

func inherits_from(script_path: String, base_path: String) -> bool:
	var current: Script = load(script_path)
	var target_base: Script = load(base_path)
	while current != null:
		if current == target_base:
			return true
		current = current.get_base_script()
	return false
