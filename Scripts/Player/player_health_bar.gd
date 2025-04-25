class_name BetterHealthBar extends ProgressBar

var tween: Tween = create_tween()
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	value_changed.connect(animate)

func animate(new_value: float) -> void:
	animator.play("twinkle")
	#var duration = animator.current_animation_length
	#tween.interpolate_value(value,  new_value - value, 0, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
