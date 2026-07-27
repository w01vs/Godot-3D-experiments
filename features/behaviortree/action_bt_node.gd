class_name ActionNodeBT extends BTNode

func execute() -> int:
	@warning_ignore("redundant_await")
	return await action()

func action() -> int:
	return FAILED
