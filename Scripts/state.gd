extends Node3D
class_name State

signal state_finished

# By default, _update is called in _process(). If set to false, _update is called in _physics_process
var execute_in_process: bool = true

func _enter_state() -> void:
	pass

func _exit_state() -> void:
	pass

func _update(delta: float) -> void:
	pass
