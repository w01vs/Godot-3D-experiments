class_name BetterHealthBar extends ProgressBar

var stylebox_1: StyleBoxFlat = StyleBoxFlat.new()
var stylebox_fill: StyleBoxFlat = StyleBoxFlat.new()
var prev_fill: float = value
var tween: Tween = create_tween()
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	stylebox_1.set_border_width_all(2)
	stylebox_1.border_color = Color.BLACK
	stylebox_1.set_corner_radius_all(8)
	stylebox_fill.set_border_width_all(2)
	stylebox_fill.border_width_right = 0
	stylebox_fill.border_color = Color.BLACK
	stylebox_fill.set_corner_radius_all(8)
	stylebox_fill.corner_radius_top_right = 0
	stylebox_fill.corner_radius_bottom_right = 0
	stylebox_fill.bg_color = Color8(183, 33, 44)
	stylebox_1.bg_color = Color8(183, 33, 44)
	value_changed.connect(animate)
	tween.finished.connect(change_stylebox)
	change_stylebox(prev_fill)

func _physics_process(delta: float) -> void:
	change_stylebox(value)

func animate(new_value: float) -> void:
	animator.play("twinkle")
	var duration = animator.current_animation_length
	tween.interpolate_value(value,  new_value - value, 0, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func change_stylebox(fill: float = 0):
	if prev_fill != 1 and fill == 1:
		remove_theme_stylebox_override("fill")
		add_theme_stylebox_override("fill", stylebox_1)
	elif fill != 1 and prev_fill == 1:
		remove_theme_stylebox_override("fill")
		add_theme_stylebox_override("fill", stylebox_fill)
	elif fill == 1 and prev_fill == 1:
		remove_theme_stylebox_override("fill")
		add_theme_stylebox_override("fill", stylebox_1)
	prev_fill = fill
