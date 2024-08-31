extends MeshInstance3D

@onready var body: StaticBody3D = $"StaticBody3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func to_holo() -> void:
	body.to_holo()
	
func place() -> void:
	body.place()
