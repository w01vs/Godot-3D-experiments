class_name ActionNodeBT extends BTNode

func execute() -> int:
	return await action()

func action() -> int:
	return FAILED
