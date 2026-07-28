class_name DamageEntityEvent extends EntityEvent

var damage_info: DamageInfo
var damage_source: Entity

func _init(_source: Node, _damage_info: DamageInfo, _damage_source: Entity) -> void:
	super(_source)
	damage_info = _damage_info
	damage_source = _damage_source
