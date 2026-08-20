class_name BuildMenuCategory extends Button

@export var label: Label
@export var group_scene: PackedScene
var groups: Dictionary[BuildGroup, BuildMenuGroup]
var category: BuildCategory

var select: Callable

func set_category(category_: BuildCategory) -> void:
	label.text = category_.name
	category = category_

func add_group(group: BuildGroup, control: Control) -> void:
	var gr: BuildMenuGroup = group_scene.instantiate()
	gr.set_group(group)
	control.add_child(gr)
	groups.set(group, gr)
	gr.hide()

func bind(binding: Callable) -> void:
	select = binding

func unbind() -> void:
	select = func() -> void: return

func add_item_to_group(item: UIBuildItemView, bindings: BuildBindings, group: BuildGroup) -> void:
	if groups.has(group):
		groups[group].add_item(item, bindings)

func has_group(group: BuildGroup) -> bool:
	return groups.has(group)

func remove_group(group: BuildGroup) -> void:
	groups.erase(group)

func show_groups() -> void:
	add_theme_color_override("icon_normal_color", Color.RED)
	for gr: BuildMenuGroup in groups.values():
		gr.show()

func hide_groups() -> void:
	remove_theme_color_override("icon_normal_color")
	for gr: BuildMenuGroup in groups.values():
		gr.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select.call(category)
