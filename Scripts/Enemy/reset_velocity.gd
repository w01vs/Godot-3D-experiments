extends ActionNodeBT

@export var actor: SimpleEnemy

func action() -> int:
	actor.velocity = Vector3.ZERO
	actor.pathfinding = false
	return SUCCESS
