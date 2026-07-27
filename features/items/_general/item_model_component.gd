class_name ItemModelComponent extends Component

var data: ItemData

func _execute_use(_player: Player) -> void:
	pass

func _on_equip(_player: Player, _itemdata: ItemData) -> void:
	pass

func on_animation_start() -> void:
	pass

func on_animation_trigger(_event: StringName = "") -> void:
	pass

func on_animation_end() -> void:
	pass

func delete() -> void:
	entity.queue_free()

func enable() -> void:
	entity.hide()
	entity.set_process(false)

func disable() -> void:
	entity.show()
