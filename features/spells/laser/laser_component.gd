class_name LaserComponent extends Component

@export var laser: Laser

func _init_component() -> void:
	InputManager.subscribe(SpellInputEvent, fire)

func fire(_event: SpellInputEvent) -> void:
	laser.fire()
