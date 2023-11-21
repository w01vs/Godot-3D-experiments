extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	if actor.nav_agent.is_target_reached():
		actor.pathfinding = false
	return actor.pathfinding
