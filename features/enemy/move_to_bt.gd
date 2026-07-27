class_name MoveToNavTargetBT extends ActionNodeBT

@export var actor: SimpleEnemy

func action() -> int:
	var next_position: Vector3 = actor.nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_position - actor.global_position).normalized() * actor.SPEED
	actor.velocity = actor.velocity.move_toward(new_velocity, .2)
	var lookdir: float = atan2(-actor.velocity.x, -actor.velocity.z)
	actor.rotation.y = lookdir
	
	actor.move_and_slide()
	return SUCCESS
