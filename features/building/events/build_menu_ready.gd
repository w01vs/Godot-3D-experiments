class_name BuildComponentReadyEvent extends Event

var bindings: BuildBindings
var data: Array[UIBuildItemView]

func _init(source_: Node, bindings_: BuildBindings, data_: Array[UIBuildItemView]) -> void:
	super(source_)
	bindings = bindings_
	data = data_
