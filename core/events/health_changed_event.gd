class_name HealthChangedEvent extends Event

var health: float
var health_percent: float

func _init(source_: Node,  health_: float,  health_percent_: float) -> void:
	super(source_)
	health = health_ 
	health_percent = health_percent_ 
