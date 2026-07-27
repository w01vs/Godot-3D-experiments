extends MeshInstance3D

@onready var body: StaticBody3D = $"StaticBody3D"

func to_holo() -> void:
	body.to_holo()
	
func place() -> void:
	body.place()
