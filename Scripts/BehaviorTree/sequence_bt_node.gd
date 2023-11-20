class_name SequenceNodeBT extends BTNode

var last_index: int = 0

func _ready() -> void:
	get_bt_children()

func execute() -> int:
	return await iteration(last_index)

func iteration(start: int) -> int:
	last_index = 0
	var result
	for i in range(start, children.size()):
			result = await children[i].execute()
			match result:
				FAILED:
					return FAILED
				RUNNING:
					last_index = i
					return RUNNING
	return SUCCESS
