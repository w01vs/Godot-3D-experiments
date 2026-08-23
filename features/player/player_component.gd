class_name PlayerComponent extends Component

# this should be a setting through a seperate resource too maybe?
var mouse_sensitivity: float = 0.001

# please make these into a resource......
var gravity: float = -9.81
var SPEED: float = 5
var JUMP_SPEED_REDUCTION: float = 5
# ----------------------------------------

var twist_input: float = 0
var pitch_input: float = 0

@export var twist_pivot: Node3D
@export var pitch_pivot: Node3D

# port to HeldItemComponent
#var right_hand_remote: RemoteTransform3D
#var right_hand: Marker3D

@export var body: CCharacterBody3D

func _init_component() -> void:
	entity.subscribe_local(self, CollisionShapeRegisteredEntityEvent, _on_body_registered)
	entity.subscribe_global(self, WorldLoadedEvent, _on_world_loaded, Event.Priority.BASE)
	InputManager.subscribe(JumpInputEvent, _jump)
	InputManager.subscribe(MouseMotionInputEvent, _on_mouse_moved)

func _on_world_loaded(_event: WorldLoadedEvent) -> void:
	entity.raise_global(PlayerLoadedEvent.new(self))

func _on_body_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if body == event.source:
		body.cset_collision_layer_value(CollisionLayer.LIVING, true)
		body.cset_collision_mask_value(CollisionLayer.LIVING, true)
		body.cset_collision_mask_value(CollisionLayer.TERRAIN, true)
		body.cset_collision_mask_value(CollisionLayer.STRUCTURE, true)

func _jump(_event: JumpInputEvent) -> void:
	if body.is_on_floor():
		body.velocity.y = 4.5

func _on_mouse_moved(event: MouseMotionInputEvent) -> void:
	twist_input = -event.screen_relative.x * mouse_sensitivity
	pitch_input = -event.screen_relative.y * mouse_sensitivity

func _process(_delta: float) -> void:
	_apply_rotations()

func _physics_process(delta: float) -> void:
	if body.is_on_floor():
		update_velocity(SPEED)
	else:
		update_velocity(JUMP_SPEED_REDUCTION)
		body.velocity.y += gravity * delta
	body.move_and_slide()

func _apply_rotations() -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	pitch_input = 0
	twist_input = 0

func update_velocity(multiplier: float) -> void:
	var input:  Vector2 = InputManager.get_movement_vector()
	var cam_basis: Basis = twist_pivot.global_transform.basis
	cam_basis.x.y = 0
	cam_basis.z.y = 0
	cam_basis = cam_basis.orthonormalized()
	var direction: Vector3 = (cam_basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		body.velocity.x = direction.x * multiplier
		body.velocity.z = direction.z * multiplier
	else:
		body.velocity.x = 0
		body.velocity.z = 0
