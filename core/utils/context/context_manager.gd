extends Node

var game_context: GameContext
var player_context: PlayerContext
@export var start_game_context: GameContext.State
@export var start_player_context: PlayerContext.State

signal context_changed()

func _ready() -> void:
	game_context = GameContext.new(start_game_context)
	player_context = PlayerContext.new(start_player_context)
	context_changed.emit()

func push_game_state(state_: GameContext.State) -> void:
	game_context.push_state(state_)
	context_changed.emit()

func pop_game_state() -> void:
	game_context.pop_state()
	context_changed.emit()

func get_game_state(offset: int = 0) -> GameContext.State:
	return game_context.get_state(offset)

func is_game_state(state: GameContext.State) -> bool:
	return state == get_game_state()

func push_player_state(state_: PlayerContext.State) -> void:
	player_context.push_state(state_)
	context_changed.emit()

func pop_player_state() -> void:
	player_context.pop_state()
	context_changed.emit()

func get_player_state(offset: int = 0) -> PlayerContext.State:
	return player_context.get_state(offset)

func is_player_state(state: PlayerContext.State) -> bool:
	return state == get_player_state()
