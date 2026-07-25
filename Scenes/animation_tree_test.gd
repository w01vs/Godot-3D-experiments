extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node: AnimationNodeAnimation = tree_root.get_node("Attack") as AnimationNodeAnimation
	node.animation = "testing"
	var x = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
