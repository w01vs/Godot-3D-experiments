class_name HitboxHitEntityEvent extends EntityEvent

var damage_info: DamageInfo

func _init(_source: Node, _damage_info: DamageInfo) -> void:
	super(_source)
	damage_info = _damage_info
