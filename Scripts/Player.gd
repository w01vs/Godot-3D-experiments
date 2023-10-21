extends RigidBody3D
class_name Player

var mouse_sensitivity: float = 0.001
var twist_input: float = 0
var pitch_input: float = 0

# Health Related
var health: float
var health_lerp_timer: float
var health_chipspeed: float = 2
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var health_bar_back: ProgressBar = $UI/HealthBarBack

@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_component.died.connect(died)
	health_component.health_changed.connect(change_health)
	health_bar.value = 1
	health = health_component.get_max_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input:  Vector3 = Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("forward", "backward")
	apply_central_force(twist_pivot.basis * input * 1200 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("refocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(45))
	pitch_input = 0
	twist_input = 0
	
	update_health_bar(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
			
func died() -> void:
	get_tree().quit()

func change_health(health: float) -> void:
	self.health = health
	health_lerp_timer = 0
	
func update_health_bar(delta: float) -> void:
	var fillF: float = health_bar.value
	var fillB: float = health_bar_back.value
	var hFraction = health / health_component.get_max_health()
	health_lerp_timer += delta
	var percent_complete: float = health_lerp_timer / health_chipspeed
	percent_complete *= percent_complete
	if fillB > hFraction:
		health_bar.value = hFraction
		health_bar_back.get_theme_stylebox("fill", "ProgressBar").bg_color = Color.RED
		health_bar_back.value = lerp(fillB, hFraction, percent_complete)
	if hFraction > fillF:
		health_bar_back.value = hFraction
		health_bar_back.get_theme_stylebox("fill", "ProgressBar").bg_color = Color.WEB_GREEN
		health_bar.value = lerp(fillF, hFraction, percent_complete)

		
		
			
		
