class_name HealthTick extends Node

var type: DamageInfo.Type = DamageInfo.Type.NONE
var _comp: HealthComponent = null

var timer: float = 0
var tick: float = 0
var tick_change: float = 0
var tick_count: int = 0

func _init(comp: HealthComponent, info: DamageInfo) -> void:
	if comp.health > 0:
		_comp = comp
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
	match type:
		HealthComponent.ChangeType.DOT:
			timer += delta
			if timer >= tick:
				timer -= tick
				tick_count -= 1
				_comp.health += tick_change
				_comp.health_changed.emit(_comp.health)
			if tick_count == 0:
				queue_free()
		_:
			pass
