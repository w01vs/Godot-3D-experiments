class_name HealthTick extends Node

var type: DamageSystem.ChangeType = DamageSystem.ChangeType.NONE
var _comp: HealthComponent = null

var timer: float = 0
var tick: float = 0
var tick_change: float = 0
var tick_count: int = 0

func _init(comp: HealthComponent, info: OnHitInformation) -> void:
	if comp.health > 0:
		_comp = comp
		match info.type:
			DamageSystem.ChangeType.DOT:
				type = info.type
				tick = info.time_per_tick
				tick_change = info.change_per_tick
				tick_count = info.health_change_total / tick_change
				if tick_count < 0:
					tick_count *= -1
				assert(tick_change ==  info.health_change_total / tick_count, "Health change does not match with changes per tick * tick count")
			_:
				pass
	else:
		queue_free()

func _process(delta: float) -> void:
	dot_update(delta)

func dot_update(delta: float) -> void:
	match type:
		DamageSystem.ChangeType.DOT:
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
