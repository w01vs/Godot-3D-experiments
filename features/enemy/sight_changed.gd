extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	var res: bool = actor.sight_changed
	actor.sight_changed = not actor.sight_changed
	return res
