class_name LaserComponent extends Component

func _init_component() -> void:
	InputManager.subscribe(SpellInputEvent, fire)

func fire(_event: SpellInputEvent) -> void:
	entity.get_node("Laser").fire()
