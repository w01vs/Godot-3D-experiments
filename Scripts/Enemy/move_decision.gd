extends ConditionalNodeBT

func condition() -> bool:
	var chance = randf()
	return chance > 0.3
