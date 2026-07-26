class_name ItemModelComponent extends Component

var data: ItemData

func _execute_use(player: Player) -> void:
	pass

func _on_equip(player: Player, itemdata: ItemData) -> void:
	pass

func on_animation_start() -> void:
	pass

func on_animation_trigger(event: StringName = "") -> void:
	pass

func on_animation_end() -> void:
	pass

func delete() -> void:
	entity.queue_free()
