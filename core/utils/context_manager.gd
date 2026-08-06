extends Node

var game_context: GameContext

var player_context: PlayerContext

signal game_context_changed(new_context: GameContext.State, old_context: GameContext.State)
signal player_context_changed(new_context: PlayerContext.State, old_context: PlayerContext.State)

func _ready() -> void:
	game_context = GameContext.new(GameContext.State.IN_WORLD)
	player_context = PlayerContext.new(PlayerContext.State.GAMEPLAY)

func push_game_state(state_: GameContext.State) -> void:
	game_context_changed.emit(state_, game_context.get_state())
	game_context.push_state(state_)

func pop_game_state() -> void:
	game_context_changed.emit(game_context.get_state(), game_context.get_state(1))
	game_context.pop_state()

func get_game_state(offset: int = 0) -> GameContext.State:
	return game_context.get_state(offset)

func is_game_state(state: GameContext.State) -> bool:
	return state == get_game_state()

func push_player_state(state_: PlayerContext.State) -> void:
	print_debug("pushed")
	player_context_changed.emit(state_, player_context.get_state())
	player_context.push_state(state_)

func pop_player_state() -> void:
	print_debug("popped")
	player_context_changed.emit(player_context.get_state(), player_context.get_state(1))
	player_context.pop_state()

func get_player_state(offset: int = 0) -> PlayerContext.State:
	return player_context.get_state(offset)

func is_player_state(state: PlayerContext.State) -> bool:
	return state == get_player_state()
