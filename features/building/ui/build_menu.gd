class_name BuildMenu extends Control

var categories: Set = Set.new()
var category_ui: Dictionary[BuildCategory, BuildMenuCategory]
@export var category_control: Control
@export var category_scene: PackedScene

@export var group_control: VBoxContainer

var active_category: BuildCategory = null


func _ready() -> void:
	EventBus.subscribe(BuildComponentReadyEvent, initialise)
	hide()
	EventBus.subscribe(BuildMenuOpenEvent, _open)
	EventBus.subscribe(BuildMenuCloseEvent, _close)

func _open(_event: BuildMenuOpenEvent) -> void:
	show()
	category_ui[active_category].show_groups()

func _close(_event: BuildMenuCloseEvent) -> void:
	hide()
	category_ui[active_category].hide_groups()

func initialise(event: BuildComponentReadyEvent) -> void:
	for item in event.data:
		add_item(item, event.bindings)

func add_item(data: UIBuildItemView, bindings: BuildBindings) -> void:
	var group: BuildGroup = data.group
	var category: BuildCategory = group.category
	if categories.contains(category):
		if category_ui[category].has_group(group):
			category_ui[category].add_item_to_group(data, group)
			return
		else:
			category_ui[category].add_group(group, group_control)
			return
	if !active_category:
		active_category = category
	categories.add(category)
	var cat: BuildMenuCategory = category_scene.instantiate()
	cat.set_title(category.name)
	cat.add_group(group, group_control)
	cat.add_item_to_group(data, group)
	cat.bind(bindings)
	category_control.add_child(cat)
	category_ui.set(category, cat)
	
