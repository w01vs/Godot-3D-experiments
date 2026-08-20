class_name World extends Node3D

func _ready() -> void:
	EventBus.raise(WorldLoadedEvent.new(self))
