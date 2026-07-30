class_name PlayerLoadedEvent extends Event

var player_context: PlayerContext

func _init(source_: Node, player_context_: PlayerContext) -> void:
	super(source_)
	player_context = player_context_
