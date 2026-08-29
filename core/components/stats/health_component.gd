class_name HealthComponent extends Component

signal died()

enum ChangeType {
	DOT = 1,
	INSTANT = 2,
	NONE = 0,
}

@export var max_health: float = 100

var health: float:
	set(value):
		health = value
		clamp(health, 0, max_health)
		entity.raise_global(HealthChangedEvent.new(self, health, health / max_health))
		health_0()

var increasing_over_time: bool = false
var increase_timer: float = 0
var increase_tick_time: float = 0
var increase_tick_amount: float = 0
var increase_total_ticks: float = 0

var decreasing_over_time: bool = false
var decrease_timer: float = 0
var decrease_tick_time: float = 0
var decrease_tick_amount: float = 0
var decrease_total_ticks: float = 0

func _init_component() -> void:
	health = max_health
	entity.subscribe(self, DamageEntityEvent, take_hit)

func take_hit(event: DamageEntityEvent) -> void:
	if event.damage_info:
		var info: DamageInfo = event.damage_info
		for n in info.groups.size():
			if entity.is_in_group(info.groups[n]):
				update_health(info)

func update_health(info: DamageInfo) -> void:
	match info.type:
		DamageInfo.Type.NONE:
			pass
		DamageInfo.Type.INSTANT:
			# info.health_change_total should be negative when dealing damage.
			health += info.health_change_total
		DamageInfo.Type.DOT:
			var ticker: HealthTick = HealthTick.new(self, info)
			add_child(ticker)

func health_0() -> void:
	if health <= 0:
		died.emit()

func set_max_health(amount: float) -> void:
	max_health = amount

func get_max_health() -> float:
	return max_health
