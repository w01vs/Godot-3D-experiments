class_name SetPlayerContextEntityEvent extends EntityEvent

var state: PlayerContext.State

func _init(source_: Node, state_: PlayerContext.State) -> void:
	super(source_)
	state = state_
