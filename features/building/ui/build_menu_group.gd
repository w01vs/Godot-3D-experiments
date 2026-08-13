class_name BuildMenuGroup extends FoldableContainer

@export var grid: GridContainer

func set_group(data: BuildGroup) -> void:
	title = data.name

func add_item(data: BuildResource) -> void:
	pass
