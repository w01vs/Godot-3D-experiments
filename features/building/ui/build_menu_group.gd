class_name BuildMenuGroup extends FoldableContainer

@export var grid: GridContainer
@export var item: PackedScene

func set_group(data: BuildGroup) -> void:
	title = data.name

func add_item(data: UIBuildItemView, bindings: BuildBindings) -> void:
	var new: BuildMenuItem = item.instantiate()
	new.set_ui(data)
	new.bind(bindings)
	grid.add_child(new)
