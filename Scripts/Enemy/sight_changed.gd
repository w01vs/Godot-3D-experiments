extends ConditionalNodeBT

@export var actor: SimpleEnemy

func condition() -> bool:
	var res = actor.sight_changed
	actor.sight_changed = not actor.sight_changed
	return res
