class_name BuildMenuCategory extends Button

@export var label: Label
var groups: Set = Set.new()
@export var group_scene: PackedScene
var group_ui: Dictionary[BuildGroup, BuildMenuGroup]

func set_title(title: StringName) -> void:
	label.text = title

func add_group(group: BuildGroup, control: Control) -> void:
	groups.add(group)
	var gr: BuildMenuGroup = group_scene.instantiate()
	gr.set_group(group)
	control.add_child(gr)
	group_ui.set(group, gr)

func add_item_to_group(item: UIBuildItemView, group: BuildGroup) -> void:
	if groups.contains(group):
		group_ui[group].add_item(item)

func has_group(group: BuildGroup) -> bool:
	return groups.contains(group)

func remove_group(group: BuildGroup) -> void:
	groups.remove(group)
	group_ui[group].queue_free()

func show_groups() -> void:
	for gr: BuildMenuGroup in group_ui.values():
		gr.show()

func hide_groups() -> void:
	for gr: BuildMenuGroup in group_ui.values():
		gr.hide()
