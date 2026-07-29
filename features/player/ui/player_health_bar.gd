class_name PlayerHealthBar extends HealthBar

@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	value_changed.connect(animate)
	EventBus.subscribe(HealthChangedEvent, _health_changed)

func _health_changed(event: HealthChangedEvent) -> void:
	value = event.health_percent * 100

func animate(_new_value: float) -> void:
	animator.play("twinkle")
