class_name IsPathfindingBT extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	return actor.pathfinding
