extends BehaviorNode
class_name PrioritySelector

var last_index: int = -1

func _ready() -> void:
	get_bt_children()
	for i in children:
		i.disable()

func _physics_process(delta) -> void:
	for i in children:
		assert(i is ConcurrentNode)
		i.visit()


func visit() -> int:
	var result
	if last_index == -1:
		return iteration(0)
	else:
		return iteration(last_index)

func iteration(start: int) -> int:
	var result
	for i in range(start, children.size()):
			result = iterate(children[i])
			if result == FAILED:
				return result
			elif result == RUNNING:
				last_index = i
				return RUNNING
	return SUCCESS

func iterate(child: BehaviorNode) -> int:
	if child is ExecutableNode:
		return child.execute()
	else:
		return child.visit()
