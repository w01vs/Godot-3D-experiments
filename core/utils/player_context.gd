class_name PlayerContext

enum State { GAMEPLAY, INVENTORY }

var state: State

func _init(state_: State) -> void:
	state = state_
