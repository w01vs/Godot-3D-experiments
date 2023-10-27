extends Node3D
class_name FiniteStateMachine

@export var state: State

func _ready() -> void:
	change_state(state)

func change_state(new_state: State) -> void:
	if state is State:
		state._exit_state()
	new_state._enter_state()
	state = new_state

func _process(delta: float) -> void:
	if state.execute_in_process:
		state._update(delta)

func _physics_process(delta: float) -> void:
	if not state.execute_in_process:
		state._update(delta)
