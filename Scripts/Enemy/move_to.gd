extends ActionNodeBT

@onready var nav_agent: NavigationAgent3D = $"../../../../NavigationAgent3D"
@onready var actor = $"../../../.."

func action() -> int:
	if nav_agent.is_target_reached():
		actor.velocity = Vector3.ZERO 
		return SUCCESS
	
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - actor.global_position).normalized() * actor.SPEED
	actor.velocity = actor.velocity.move_toward(new_velocity, .4)
	
	actor.move_and_slide()
	return RUNNING
