class_name InteractableComponent extends Node

@export var body: CollisionObject3D = null

func _ready() -> void:
	body.set_collision_layer_value(2, true)
	body.set_meta("interactable", self)

func interact(interacter: Node3D) -> void:
	get_parent().interact(interacter)
