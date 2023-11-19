extends ExecutableNodeBT

var player

func _ready() -> void:
	player = GlobalRefs.player
	priority = 0

func execute() -> int:
	return FAILED
