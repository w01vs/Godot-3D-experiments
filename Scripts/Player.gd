extends Node3D
class_name Player

var mouse_sensitivity: float = 0.001
var twist_input: float = 0
var pitch_input: float = 0
var gravity: float = -9.81

# Health Related
var health: float
var health_lerp_timer: float
var health_chipspeed: float = 2
@onready var health_component: HealthComponent = $HealthComponent
#@onready var health_bar: TextureProgressBar = $UILayer/Control/healthbar/front
#@onready  var health_bar_back: TextureProgressBar = $UILayer/Control/healthbar/front/back
@onready var character: CharacterBody3D = $CharacterBody3D

# Camera pivots
@onready var twist_pivot: Node3D = $CharacterBody3D/TwistPivot
@onready var pitch_pivot: Node3D = $CharacterBody3D/TwistPivot/PitchPivot

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_component.died.connect(died)
	health_component.health_changed.connect(change_health)
	#health_bar.value = 1
	#health = health_component.get_max_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(45))
	pitch_input = 0
	twist_input = 0
	
#	update_health_bar(delta)

func _physics_process(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and character.is_on_floor():
		character.velocity.y = 4.5
	
	var input:  Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction = (twist_pivot.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		character.velocity.x = direction.x * 5
		character.velocity.z = direction.z * 5
	else:
		character.velocity.x = 0
		character.velocity.z = 0
		
	character.move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("refocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("default_attack"):
		anim_player.play("sword_slash")

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

#func update_health_bar(delta: float) -> void:
#	var fillF: float = health_bar.value
#	var fillB: float = health_bar_back.value
#	var hFraction = health / health_component.get_max_health()
#	health_lerp_timer += delta
#	var percent_complete: float = health_lerp_timer / health_chipspeed
#	percent_complete *= percent_complete
#	if fillB > hFraction:
#		health_bar.value = hFraction
#		health_bar_back.get_theme_stylebox("fill", "ProgressBar").bg_color = Color.RED
#		health_bar_back.value = lerp(fillB, hFraction, percent_complete)
#	if hFraction > fillF:
#		health_bar_back.value = hFraction
#		health_bar_back.get_theme_stylebox("fill", "ProgressBar").bg_color = Color.WEB_GREEN
#		health_bar.value = lerp(fillF, hFraction, percent_complete)
