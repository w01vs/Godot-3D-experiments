extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	var chance: float = randf()
	return chance > 0.3 || actor.pathfinding
