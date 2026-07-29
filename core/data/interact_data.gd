class_name InteractionData extends CollisionData

var hover: bool

func _init(source_: Entity, hover_: bool) -> void:
	super(source_)
	hover = hover_
