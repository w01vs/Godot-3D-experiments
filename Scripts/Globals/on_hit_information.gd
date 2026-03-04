class_name OnHitInformation extends Resource

# Which groups should it affect?
@export var groups: Array[String] = []

# Health changes?
@export var type: DamageSystem.ChangeType = DamageSystem.ChangeType.NONE
# Anything relating to health
@export var health_change_total: float = 0
# @@show_if(type == 1)
@export var change_per_tick: float = 0
# @@show_if(type == 1)
@export var time_per_tick: float = 0
@export var damage_multiplier: float = 1
#@export_category()
# Anything relating to positional effects
@export var has_position_effect_info: bool = false
# @@show_if(has_position_effect_info)
@export var knockback: float = 0
# @@show_if(has_position_effect_info)
@export var stun_time: float = 0
