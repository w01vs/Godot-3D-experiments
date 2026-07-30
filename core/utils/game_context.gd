class_name GameContext

enum GameState { MAIN_MENU, IN_WORLD }

var state: GameState

var player_context: PlayerContext

func _init(state_: GameState, player_context_: PlayerContext) -> void:
	state = state_
	player_context = player_context_
