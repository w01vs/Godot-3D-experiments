class_name OnHitInformation

# Which groups should it affect?
var groups = []

# Health changes?
var type: DamageSystem.ChangeType = DamageSystem.ChangeType.NONE

# Anything relating to health
var health_change_total: float = 0
var change_per_tick: float = 0
var time_per_tick: float = 0
var damage_multiplier: float = 1

# Anything relating to positional effects
var has_position_effect_info: bool = false
var knockback: float = 0
var stun_time: float = 0
