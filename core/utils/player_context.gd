class_name PlayerContext

enum State { NONE, GAMEPLAY, INVENTORY, STATIC_INVENTORY, BUILDING }

var state_stack: Array[State]

func _init(state_: State) -> void:
	state_stack.append(state_)

func push_state(state_: State) -> void:
	state_stack.push_back(state_)

func pop_state() -> void:
	if state_stack.size() > 1:
		state_stack.pop_back()

func get_state(offset: int = 0) -> State:
	if state_stack.size() > offset:
		return state_stack[state_stack.size() - 1 - offset]
	push_error("State offset does not exist")
	return State.NONE
