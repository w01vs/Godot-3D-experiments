class_name ConcurrentNodeBT extends BTNode

@export_category("Settings")
@export var fail_count_requirement: bool = false
@export var max_failures: int

var last_index: int = 0

func _ready() -> void:
	get_bt_children()

func execute() -> int:
	return await iteration(last_index)

func iteration(index: int) -> int:
	last_index = 0
	for i in range(index, children.size()):
		var child: BTNode = children[i]
		var result: int = await child.execute()
		var failed_children: int = 0
		match result:
			FAILED:
				failed_children += 1
				if child is ConditionalNodeBT:
					return FAILED
			RUNNING:
				last_index = i
				return RUNNING
		if fail_count_requirement and failed_children > max_failures:
			return FAILED
	return SUCCESS
