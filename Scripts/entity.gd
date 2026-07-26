class_name Entity extends Node3D

var components: Dictionary[Script, Component] = {}

signal loaded()

func _ready() -> void:
	loaded.emit()

func register(component: Component) -> void:
	for s in find_bases(component.get_script()):
		components.set(s, component)

func get_component(script: Script) -> Component:
	return components.get(script)

func has_component(script: Script) -> bool:
	return components.has(script)

func remove_component(component: Component) -> void:
	for s in find_bases(component.get_script()):
		if get_component(s) == component:
			components.erase(component)
	pass

func find_bases(script: Script) -> Array[Script]:
	var current_script: Script = script
	var scripts: Array[Script] = []
	while current_script != Component:
		scripts.append(script)
		current_script = script.get_base_script()
	return scripts
	
