extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	return actor.sight_changed
