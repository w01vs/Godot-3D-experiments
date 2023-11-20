extends ActionNodeBT

var timer: float = 0

func action() -> int:
	update_timer()
	print_debug(timer)
	if check_timer(3):
		return SUCCESS
	return RUNNING

func update_timer() -> void:
	timer += get_physics_process_delta_time()

func reset_timer() -> void:
	timer = 0

func check_timer(time: float) -> bool:
	if timer >= time:
		reset_timer()
		return true
	return false
