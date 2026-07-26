@tool
class_name OnHitInformation extends Resource

# Which groups should it affect?
@export var groups: Array[String] = []

# Health changes?
@export var type: DamageSystem.ChangeType:
	set(value):
		type = value
		notify_property_list_changed()
# Anything relating to health
@export var health_change_total: float = 0
@export var change_per_tick: float = 0
@export var time_per_tick: float = 0
@export var ticks: int = 0
@export var damage_multiplier: float = 1
#@export_category()
# Anything relating to positional effects
@export_group("Knockback")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var has_position_effect_info: bool = false
@export var knockback: float = 0
@export var stun_time: float = 0

func _validate_property(property: Dictionary) -> void:
	enable_if(property, "time_per_tick", type == DamageSystem.ChangeType.DOT)
	enable_if(property, "change_per_tick", type == DamageSystem.ChangeType.DOT)
	enable_if(property, "ticks", type == DamageSystem.ChangeType.DOT)
	enable_if(property, "health_change_total", type == DamageSystem.ChangeType.INSTANT)
	enable_if(property, "damage_multiplier", type == DamageSystem.ChangeType.INSTANT)

func enable_if(property: Dictionary, name: String, condition: bool) -> void:
	if property.name == name and !condition:
		property.usage = PROPERTY_USAGE_READ_ONLY
