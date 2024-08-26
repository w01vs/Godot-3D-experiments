extends RayCast3D

var current_collider: Interactable

signal ui_switched

@onready var player: Node3D = $"../../../.."

enum States {DEFAULT = 0, BUILD = 1}

var state : States = States.DEFAULT

func _process(_delta: float) -> void:
	match state:
		States.DEFAULT:
			collision()
		States.BUILD:
			pass

func collision() -> void:
	var collider = get_collider()
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			current_collider = collider
		
		if(Input.is_action_just_pressed("interact")):
			collider.interact(player)
	elif current_collider:
		current_collider = null


func _physics_process(delta: float) -> void:
	match state:
		States.DEFAULT: 
			state = States.BUILD
			ui_switched.emit(state)
			if Input.is_action_just_pressed("build"):
				target_position.y = -15
			# instance an object and position it at the intersection point of the ray.
		States.BUILD:
			state = States.DEFAULT
			ui_switched.emit(state)
			if Input.is_action_just_pressed("build"):
				target_position.y = -5
