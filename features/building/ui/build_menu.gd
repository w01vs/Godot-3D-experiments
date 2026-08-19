class_name BuildMenu extends Control

var categories: Set = Set.new()
var category_ui: Dictionary[BuildCategory, BuildMenuCategory]
@export var category_control: Control
@export var category_scene: PackedScene

@export var group_control: VBoxContainer

func _ready() -> void:
	EventBus.subscribe(BuildComponentReadyEvent, initialise)

func initialise(event: BuildComponentReadyEvent) -> void:
	for item in event.data:
		add_item(item)

func add_item(data: UIBuildItemView) -> void:
	var group: BuildGroup = data.group
	var category: BuildCategory = group.category
	if categories.contains(category):
		if category_ui[category].has_group(group):
			category_ui[category].add_item_to_group(data, group)
			return
		else:
			category_ui[category].add_group(group, group_control)
			return
	categories.add(category)
	var cat: BuildMenuCategory = category_scene.instantiate()
	cat.add_group(group, group_control)
	category_control.add_child(cat)
	
