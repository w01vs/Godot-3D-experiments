class_name DamageEntityEvent extends EntityEvent

var damage_info: DamageInfo
var damage_source: Entity

func _init(source_: Node, damage_info_: DamageInfo, damage_source_: Entity) -> void:
	super(source_)
	damage_info =damage_info_ 
	damage_source = damage_source_
