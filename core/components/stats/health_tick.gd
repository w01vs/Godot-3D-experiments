class_name HealthTick extends Node

var type: DamageInfo.Type = DamageInfo.Type.NONE
var comp_: HealthComponent = null

var timer: float = 0
var tick: float = 0
var tick_change: float = 0
var tick_count: int = 0

func _init(comp: HealthComponent, info: DamageInfo) -> void:
	if comp.health > 0:
		comp_ = comp
		match info.type:
			DamageInfo.Type.DOT:
				type = info.type
				tick = info.time_per_tick
				tick_change = info.change_per_tick
				tick_count = info.ticks
				if tick_count < 0:
					tick_count *= -1
				assert(tick_count > 0, "No ticks on this a DOT effect?")
			_:
				pass
	else:
		queue_free()

func _process(delta: float) -> void:
	dot_update(delta)

func dot_update(delta: float) -> void:
	timer += delta
	if timer >= tick:
		timer -= tick
		tick_count -= 1
		comp_.health += tick_change
	if tick_count == 0:
		queue_free()
