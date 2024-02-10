class_name InvertNodeBT extends BTNode

func _ready() -> void:
	get_bt_children()
	assert(children.size() == 1)

func execute() -> int:
	var res: int = await children[0].execute()
	if res == SUCCESS:
		return FAILED
	elif res == RUNNING:
		return RUNNING
	return SUCCESS
