extends Node3D

@export var play: bool = false

func _physics_process(delta: float) -> void:
	if play:
		$AnimationPlayer.play("slash")
