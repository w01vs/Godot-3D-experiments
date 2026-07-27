@tool
extends Node

func _validate_property(property: Dictionary) -> void:
	if property.name == "target_component":
		var non_abstract_classes: Array[String] = InspectorHelp._get_derived_component_classes(CArea3D)
		var enum_hint_string: String = ",".join(non_abstract_classes)
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = enum_hint_string

func _get_derived_component_classes(required: Script) -> Array[String]:
	var result: Array[String] = []
	var global_classes: Array[Dictionary] = ProjectSettings.get_global_class_list()
	
	for class_info in global_classes:
		var script_path: String = class_info.path
		if _inherits_from(script_path, "res://core/components/component.gd"):
			var script_res: GDScript = load(script_path) as GDScript
			if script_res and not script_res.is_abstract():
				var tags: Set = script_res._get_tags()
				if tags.contains(required):
					result.append(class_info.class)
	return result

func _inherits_from(script_path: String, base_path: String) -> bool:
	var current: Script = load(script_path)
	var target_base: Script = load(base_path)
	while current != null:
		if current == target_base:
			return true
		current = current.get_base_script()
	return false
