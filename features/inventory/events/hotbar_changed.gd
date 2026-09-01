class_name HotbarActiveChangedEvent extends Event

var index: int
var old_index: int

func _init(source_: Node, index_: int, old_index_: int) -> void:
	super(source_)
	index = index_
	old_index = old_index_
