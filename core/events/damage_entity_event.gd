class_name DamageEntityEvent extends EntityEvent

var damage_info: OnHitInformation

func _init(_source: Node, _damage_info: OnHitInformation) -> void:
	super(_source)
	damage_info = _damage_info
