class_name BTRoot extends BTNode

func _ready() -> void:
	get_bt_children()

func _physics_process(_delta: float) -> void:
	for child in children:
		child.execute()
