class_name PlayerComponent extends Component

# please make these into a resource......
var mouse_sensitivity: float = 0.001
var gravity: float = -9.81

var SPEED: float = 5
var JUMP_SPEED_REDUCTION: float = 5
# ----------------------------------------

var twist_input: float = 0
var pitch_input: float = 0

@export var twist_pivot: Node3D
@export var pitch_pivot: Node3D

var right_hand_remote: RemoteTransform3D
var right_hand: Marker3D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree

var body: CCharacterBody3D

func _init_component() -> void:
	InputManager.subscribe(CollisionShapeRegisteredEntityEvent, _on_body_registered)
	InputManager.subscribe(JumpInputEvent, _jump)

func _on_body_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CCharacterBody3D:
		body = event.source

func _jump(_event: JumpInputEvent) -> void:
	if body.is_on_floor():
		body.velocity.y = 4.5

func _physics_process(delta: float) -> void:
	if body.is_on_floor():
		update_velocity(SPEED)
	else:
		update_velocity(JUMP_SPEED_REDUCTION)
		body.velocity.y += gravity * delta
	body.move_and_slide()
	# until i swap to InputManager
	if OS.is_debug_build():
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("refocus"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# until i swap to InputManager
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity

func _apply_rotations() -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	pitch_input = 0
	twist_input = 0

# until i swap to InputManager
func update_velocity(multiplier: float) -> void:
	var input:  Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (twist_pivot.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		body.velocity.x = direction.x * multiplier
		body.velocity.z = direction.z * multiplier
	else:
		body.velocity.x = 0
		body.velocity.z = 0
