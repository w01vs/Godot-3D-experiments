class_name InvertNodeBT extends BTNode

func _ready() -> void:
	get_bt_children()
	if(children.size() > 1):
		# Throw an error or something
		pass

func execute() -> int:
	var res: int = children[0].execute()
	if res == SUCCESS:
		return FAILED
	elif res == RUNNING:
		return RUNNING
	return SUCCESS
