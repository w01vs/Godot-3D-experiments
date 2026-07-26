class_name ComponentRayCast3D extends RayCast3D

signal hit(entity: Entity)

func _ready() -> void:
	collide_with_areas = true
	collide_with_bodies = false
