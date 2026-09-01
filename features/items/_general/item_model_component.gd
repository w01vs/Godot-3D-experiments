class_name ItemModelComponent extends Component

var data: ItemData
var user: Entity

func load(entity_: Entity, data_: ItemData) -> void:
	data = data_
	user = entity_

func equip() -> void:
	_on_equip()

func unequip() -> void:
	_on_unequip()

func _execute_use() -> void:
	pass

func _on_equip() -> void:
	pass

func _on_unequip() -> void:
	pass

func on_animation_start(_name: StringName) -> void:
	pass

func on_animation_trigger(_event: StringName = "") -> void:
	pass

func on_animation_end(_name: StringName) -> void:
	pass

func delete() -> void:
	unequip()
	disable()
	entity.queue_free()

func enable() -> void:
	entity.enable()

func disable() -> void:
	entity.disable()
