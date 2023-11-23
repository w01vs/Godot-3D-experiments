class_name BTRoot extends BTNode

func _ready() -> void:
	get_bt_children()

func _physics_process(delta: float) -> void:
	for child in children:
		await child.execute()
