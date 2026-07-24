class_name AnimationComponent extends Component

@export var animation: String

func _init_component() -> void:
	type = ComponentType.ANIMATOR

func on_animation_start() -> void:
	pass

func on_animation_trigger(event: String) -> void:
	pass

func on_animation_end() -> void:
	pass
