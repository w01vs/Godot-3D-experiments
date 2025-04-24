class_name Health_Interactable extends Node3D

@export var health_change: float
@export var type: DamageSystem.ChangeType
@export_group("Only with DOT")
@export var change_per_tick: float = 0
@export var time_per_tick: float = 0

func interact(interacter: Node3D) -> void:
	var info = OnHitInformation.new()
	info.type = type
	info.change_per_tick = change_per_tick
	info.time_per_tick = time_per_tick
	info.health_change_total = health_change
	interacter.get_node("HealthComponent").update_health(info)
