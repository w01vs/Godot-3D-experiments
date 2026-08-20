class_name PlayerQuery extends ContextQuery

@export var state: PlayerContext.State

func _init(state_: PlayerContext.State = PlayerContext.State.NONE) -> void:
	state = state_

func validate() -> bool:
	return ContextManager.is_player_state(state)
