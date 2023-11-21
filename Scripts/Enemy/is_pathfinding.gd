extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	return not actor.pathfinding
