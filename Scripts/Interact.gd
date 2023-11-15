extends RayCast3D

var current_collider: Interactable

@onready var player: Node3D = $"../../../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	collision()
		
func collision() -> void:
	var collider = get_collider()
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			current_collider = collider
		
		if(Input.is_action_just_pressed("interact")):
			collider.interact(player)
	elif current_collider:
		current_collider = null
