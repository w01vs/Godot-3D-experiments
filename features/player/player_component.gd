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

var body: CCharacterBody3D

var context: PlayerContext

func _init_component() -> void:
	entity.subscribe_local(CollisionShapeRegisteredEntityEvent, _on_body_registered)
	EventBus.subscribe(WorldLoadedEvent, _on_world_loaded, Event.Priority.BASE)
	InputManager.subscribe(JumpInputEvent, _jump)
	InputManager.subscribe(MouseMotionInputEvent, _on_mouse_moved)
	InputManager.subscribe(BuildInputEvent, _on_buildmode)
	context = PlayerContext.new(PlayerContext.State.GAMEPLAY)

func _on_world_loaded(_event: WorldLoadedEvent) -> void:
	EventBus.raise(PlayerLoadedEvent.new(self, context))

func _on_inventory(_event: InventoryInputEvent) -> void:
	if context.state != PlayerContext.State.INVENTORY:
		context.state = PlayerContext.State.INVENTORY
		entity.raise_local(InventoryOpenEntityEvent.new(self))
	else:
		context.state = PlayerContext.State.GAMEPLAY
		entity.raise_local(InventoryCloseEntityEvent.new(self))
	
	

func _on_buildmode(event: BuildInputEvent) -> void:
	pass

func _on_body_registered(event: CollisionShapeRegisteredEntityEvent) -> void:
	if event.source is CCharacterBody3D:
		body = event.source

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
	var input:  Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (twist_pivot.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		body.velocity.x = direction.x * multiplier
		body.velocity.z = direction.z * multiplier
	else:
		body.velocity.x = 0
		body.velocity.z = 0
