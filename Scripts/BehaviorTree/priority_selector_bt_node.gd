class_name PrioritySelectorBT extends BTNode

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
				RUNNING:
					last_index = i
					return RUNNING
				SUCCESS:
					return SUCCESS
	return FAILED
