class_name OnHitInformation

# Anything relating to damage
var has_damage_info: bool = false
var damage: float = 0
var damage_over_time: float = 0
var timer_dot: float = 0
var damage_multiplier = 1

# Anything relating to healing
var has_healing_info = false
var heal: float = 0

# Anything relating to positional effects
var has_position_effect_info: bool = false
var knockback: float = 0
var stun_time: float = 0
