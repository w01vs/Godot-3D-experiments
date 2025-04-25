class_name BetterHealthBar extends ProgressBar

@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	value_changed.connect(animate)

func animate(new_value: float) -> void:
	animator.play("twinkle")
