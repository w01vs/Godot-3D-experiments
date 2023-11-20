class_name ConditionalNodeBT extends BTNode

func execute() -> int:
	if condition():
		return SUCCESS
	return FAILED

func condition() -> bool:
	return false
