extends ActionNodeBT

@export var actor: SimpleEnemy

func action() -> int:
	actor.nav_agent.target_position = GlobalRefs.player.global_position
	if not actor.nav_agent.is_target_reachable():
		return FAILED
	actor.pathfinding = true
	return SUCCESS
