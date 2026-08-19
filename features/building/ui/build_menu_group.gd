class_name BuildMenuGroup extends FoldableContainer

@export var grid: GridContainer
@export var item: PackedScene

func set_group(data: BuildGroup) -> void:
	title = data.name

func add_item(data: UIBuildItemView) -> void:
	var new: BuildMenuItem = item.instantiate()
	new.set_ui(data)
	grid.add_child(new)
