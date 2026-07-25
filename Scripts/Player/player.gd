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
@export var health_component: HealthComponent

var held_item: ItemModelComponent
var using_held_item: bool = false
var hotbar_items: Array[ItemModelComponent]

# Camera pivots
@export var twist_pivot: Node3D
@export var pitch_pivot: Node3D

@export var inventory: Inventory
@export var right_hand_remote: RemoteTransform3D
@export var right_hand: Marker3D
@export var anim_player: AnimationPlayer
@export var anim_tree: AnimationTree

func _ready() -> void:
	hotbar_items.resize(inventory.HOTBAR_SIZE)
	GlobalRefs.player = self
	GlobalRefs.player_set.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_component.died.connect(died)

func _process(_delta: float) -> void:
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
	if OS.is_debug_build():
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("refocus"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("default_attack") and !using_held_item:
		if held_item:
			held_item._execute_use(self)
			using_held_item = true

func _input(event: InputEvent) -> void:
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

func hotbar_load_item(model: Node3D, index: int, itemdata: ItemData) -> void:
	if hotbar_items[index]:
		hotbar_items[index].delete()
	model.hide()
	_update_held_item(model)
	held_item = model.get_meta(ComponentType.ITEM)
	hotbar_items[index] = held_item
	held_item._on_equip(self, itemdata)
	model.show()
	#if hotbar_items[index] is Tool:
		#hotbar_items[index].resource_harvested.connect(receive_item)

func receive_item(itemdata: ItemData, amount: int) -> void:
	inventory.add_item(itemdata, amount)

func switch_hotbar_slot(index: int) -> void:
	var old_item = held_item
	held_item = hotbar_items[index]
	if old_item:
		old_item.process_mode = Node.PROCESS_MODE_DISABLED
		old_item.hide()
	if held_item:
		held_item.process_mode = Node.PROCESS_MODE_ALWAYS
		held_item.show()

func _update_held_item(model: Node3D) -> void:
	if model:
		right_hand.add_child(model)
		right_hand_remote.remote_path = right_hand_remote.get_path_to(model)

func hotbar_unload_item(index: int) -> void:
	if hotbar_items[index]:
		hotbar_items[index].hide()
		hotbar_items[index].queue_free()

func _on_animation_trigger(event: String):
	if held_item:
		held_item.on_animation_trigger(event)

func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	if held_item:
		held_item.on_animation_end()
		using_held_item = false

func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	if held_item:
		held_item.on_animation_start()
