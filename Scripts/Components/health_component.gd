class_name HealthComponent extends Node

signal health_changed(float)
signal died()

@export var max_health: float = 100

var health: float

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

func _ready() -> void:
	health = max_health
	health_changed.emit(health)

func _process(delta: float) -> void:
	clamp_health()
	health_0()
	increase_health_over_time(delta)
	decrease_health_over_time(delta)

func update_health(info: OnHitInformation) -> void:
	if info.type == DamageSystem.ChangeType.NONE:
		pass
	elif info.type == DamageSystem.ChangeType.INSTANT:
		# info.health_change_total should be negative when dealing damage.
		health += info.health_change_total
		health_changed.emit(health)
	else:
		var ticker = HealthTick.new(self, info)
		add_child(ticker)

func decrease_health(amount: float, apply_over_time: bool = false, tick_time: float = 0, per_tick: float = 0) -> void:
	if health > 0:
		if not apply_over_time:
			health -= amount
			clamp_health()
			health_changed.emit(health)
		elif not decreasing_over_time:
			decrease_timer = tick_time
			decreasing_over_time = apply_over_time
			decrease_tick_time = tick_time
			decrease_tick_amount = per_tick
			decrease_total_ticks = amount / per_tick

func increase_health(amount: float, apply_over_time: bool = false, tick_time: float = 0, per_tick: float = 0) -> void:
	if health < max_health:
		if not apply_over_time:
			health += amount
			clamp_health()
			health_changed.emit(health)
		elif not increasing_over_time:
			increase_timer = tick_time
			increasing_over_time = apply_over_time
			increase_tick_time = tick_time
			increase_tick_amount = per_tick
			increase_total_ticks = amount / per_tick

func increase_health_over_time(time: float) -> void:
	if increasing_over_time:
		increase_timer += time
		if increase_timer > increase_tick_time:
			increase_health(increase_tick_amount)
			increase_timer = 0
			increase_total_ticks -= 1
		if increase_total_ticks == 0:
			increasing_over_time = false

func decrease_health_over_time(time: float) -> void:
	if decreasing_over_time:
		decrease_timer += time
		if decrease_timer > decrease_tick_time:
			decrease_health(decrease_tick_amount)
			decrease_total_ticks -= 1
			decrease_timer = 0
		if decrease_total_ticks == 0:
			decreasing_over_time = false

func health_0() -> void:
	if health <= 0:
		died.emit()

func clamp_health() -> void:
	health = clamp(health, 0, max_health)

func set_max_health(amount: float) -> void:
	max_health = amount

func get_max_health() -> float:
	return max_health
