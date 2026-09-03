class_name CStaticBody3D extends StaticBody3D

@export var entity: Entity

func _ready() -> void:
	if !Engine.is_editor_hint():
		assert(entity != null)
		collision_layer = 0
		collision_mask = 0
		add_to_group(Groups.CUSTOM_COLLISION_OBJECT)

func enter(data: CollisionData) -> void:
	entity.emit_local(CollisionEnteredEntityEvent.new(self, data))

func oneshot(data: CollisionData) -> void:
	entity.emit_local(CollisionOneshotEntityEvent.new(self, data))

func exit(data: CollisionData) -> void:
	entity.emit_local(CollisionExitEntityEvent.new(self, data))

func cset_collision_mask_value(value: int, on: bool) -> void:
	set_collision_mask_value(value, on)

func cset_collision_layer_value(value: int, on: bool) -> void:
	set_collision_layer_value(value, on)
