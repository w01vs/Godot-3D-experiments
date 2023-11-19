class_name RegularNodeBT extends BTNode

var last_index: int = -1

func _ready() -> void:
	get_bt_children()

func visit() -> int:
	return -1
