class_name BuildMenuItem extends PanelContainer

var bindings: BuildBindings
var id: int

@export var icon: TextureRect
@export var label: Label

func set_ui(item: UIBuildItemView) -> void:
	icon.texture = item.icon
	id = item.id
	label.text = item.name

func bind(bindings_: BuildBindings) -> void:
	bindings = bindings_

func unbind() -> void:
	bindings = null

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# grab / drop item
			bindings.select.call(id)
