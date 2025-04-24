class_name NavTargetReachedBT extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	if actor.nav_agent.is_target_reached():
		actor.pathfinding = false
		return true
	return false
