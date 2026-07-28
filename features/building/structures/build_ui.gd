extends Label

var player: Player
var interact: CRayCast3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	EventBus.subscribe(PlayerLoadedEvent, init, Event.Priority.BASE)

func init(event: PlayerLoadedEvent) -> void:
	player = event.source
	#interact = player.get_node("TwistPivot/PitchPivot/Camera3D/Interact")
	#interact.ui_switched.connect(switch)
	
func switch(state: GlobalRefs.PlayerState) -> void:
	match state:
		GlobalRefs.PlayerState.DEFAULT:
			visible = false
		GlobalRefs.PlayerState.BUILD:
			visible = true
	
	
	
