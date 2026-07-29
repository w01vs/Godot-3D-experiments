class_name HitData extends CollisionData

var damage_info: DamageInfo

func _init(source_: Entity, damage_info_: DamageInfo) -> void:
	super(source_)
	damage_info = damage_info_
