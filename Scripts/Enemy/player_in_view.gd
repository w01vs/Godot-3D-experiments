extends ConditionalNodeBT

var player

@onready var actor = $"../../.."

func _ready() -> void:
	player = GlobalRefs.player
	priority = 1

func condition() -> bool:
	return false
