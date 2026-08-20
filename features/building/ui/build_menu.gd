class_name BuildMenu extends Control

var categories: Dictionary[BuildCategory, BuildMenuCategory]
@export var category_control: Control
@export var category_scene: PackedScene

@export var menu: Control
@export var placing: Control

@export var group_control: VBoxContainer

var active_category: BuildCategory = null


func _ready() -> void:
	EventBus.subscribe(BuildComponentReadyEvent, initialise)
	hide()
	EventBus.subscribe(BuildMenuOpenEvent, _open)
	EventBus.subscribe(BuildMenuCloseEvent, _close)

func _open(_event: BuildMenuOpenEvent) -> void:
	show()
	categories[active_category].show_groups()

func _close(_event: BuildMenuCloseEvent) -> void:
	hide()
	categories[active_category].hide_groups()

func initialise(event: BuildComponentReadyEvent) -> void:
	for item in event.data:
		add_item(item, event.bindings)

func add_item(data: UIBuildItemView, bindings: BuildBindings) -> void:
	var group: BuildGroup = data.group
	var category: BuildCategory = group.category
	if categories.has(category):
		if categories[category].has_group(group):
			categories[category].add_item_to_group(data, bindings, group)
			return
		else:
			categories[category].add_group(group, group_control)
			return
	if !active_category:
		active_category = category
	var cat: BuildMenuCategory = category_scene.instantiate()
	cat.set_category(category)
	cat.add_group(group, group_control)
	cat.add_item_to_group(data, bindings, group)
	cat.bind(set_active_category)
	category_control.add_child(cat)
	categories.set(category, cat)

func set_active_category(category: BuildCategory) -> void:
	if categories.has(category):
		pass
