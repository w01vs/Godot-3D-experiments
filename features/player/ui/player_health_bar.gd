class_name PlayerHealthBar extends HealthBar

@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	value_changed.connect(animate)

func animate(_new_value: float) -> void:
	animator.play("twinkle")
