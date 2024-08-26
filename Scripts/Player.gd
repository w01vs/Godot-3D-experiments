class_name Player extends CharacterBody3D

var mouse_sensitivity: float = 0.001
var twist_input: float = 0
var pitch_input: float = 0
var gravity: float = -9.81

# Player Stats
var SPEED: float = 5
var JUMP_SPEED_REDUCTION: float = 5

# Health Related
var health: float
var health_lerp_timer: float
var health_chipspeed: float = 2
@onready var health_component: HealthComponent = $HealthComponent

# Camera pivots
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var hitbox: HitboxComponent = $TwistPivot/RightArm/rightarm/sword/HitboxComponent

func _ready() -> void:
	GlobalRefs.player = self
	GlobalRefs.player_set.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_component.died.connect(died)

func _process(delta: float) -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	pitch_input = 0
	twist_input = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 4.5
	
	if is_on_floor():
		updateVelocity(SPEED)
	else:
		updateVelocity(JUMP_SPEED_REDUCTION)
		velocity.y += gravity * delta
		
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("refocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("default_attack"):
		anim_player.play("slash_attack")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity

func died() -> void:
	queue_free()

func updateVelocity(multiplier: float) -> void:
	var input:  Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction = (twist_pivot.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		velocity.x = direction.x * multiplier
		velocity.z = direction.z * multiplier
	else:
		velocity.x = 0
		velocity.z = 0

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "slash_attack":
		hitbox.set_physics_process(false)

func _on_animation_player_animation_started(anim_name):
	if anim_name == "slash_attack":
		hitbox.set_physics_process(true)
