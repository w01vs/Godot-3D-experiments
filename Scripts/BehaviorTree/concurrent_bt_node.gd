extends BehaviorNode
class_name ConcurrentNode

var last_index: int = -1

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
				return result
			elif result == RUNNING:
				last_index = i
				return RUNNING
	return SUCCESS

func iterate(child: BehaviorNode) -> int:
	if child is ExecutableNode:
		return await child.execute()
	else:
		return await child.visit()
