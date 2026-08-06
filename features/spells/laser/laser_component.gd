class_name LaserComponent extends Component

@export var laser: Entity

func _init_component() -> void:
	InputManager.subscribe(SpellInputEvent, fire)

func fire(_event: SpellInputEvent) -> void:
	laser.get_node("Laser").fire()
