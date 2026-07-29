class_name HitboxHitEntityEvent extends EntityEvent

var damage_info: DamageInfo

func _init(source_: Node, damage_info_: DamageInfo) -> void:
	super(source_)
	damage_info = damage_info_
