class_name GameQuery extends ContextQuery

@export var state: GameContext.State

func _init(state_: GameContext.State = GameContext.State.NONE) -> void:
	state = state_

func validate() -> bool:
	return ContextManager.is_game_state(state)
