class_name SequenceNodeBT extends RegularNodeBT

func _ready() -> void:
	get_bt_children()

func visit() -> int:
	var result
	if last_index == -1:
		return await iteration(0)
	else:
		return await iteration(last_index)

func iteration(start: int) -> int:
	var result
	for i in range(start, children.size()):
			result = await iterate(children[i])
			if result == FAILED:
				last_index = -1
				return result
			elif result == RUNNING:
				last_index = i
				return RUNNING
	last_index = -1
	return SUCCESS

func iterate(child: BTNode) -> int:
	if child is ExecutableNodeBT:
		return await child.execute()
	else:
		return child.visit()
