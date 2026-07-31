class_name InventoryOpenEntityEvent extends EntityEvent

var is_player: bool

func _init(source_: Node, is_player_: bool) -> void:
	super(source_)
	is_player = is_player_
