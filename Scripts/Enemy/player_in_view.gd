extends ConditionalNodeBT

var player

func _ready() -> void:
	player = GlobalRefs.player
	priority = 1

func condition() -> bool:
	return false
