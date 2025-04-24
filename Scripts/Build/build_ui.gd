extends Label

var player: Player
var interact: RayCast3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GlobalRefs.player_set.connect(init)

func init() -> void:
	player = GlobalRefs.player
	interact = player.get_node("TwistPivot/PitchPivot/Camera3D/Interact")
	interact.ui_switched.connect(switch)
	
func switch(state: GlobalRefs.PlayerState) -> void:
	match state:
		GlobalRefs.PlayerState.DEFAULT:
			visible = false
		GlobalRefs.PlayerState.BUILD:
			visible = true
	
	
	
