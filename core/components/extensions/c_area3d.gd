class_name CArea3D extends Area3D

@export var entity: Entity

var shapes: Array[CollisionShape3D]

func _ready() -> void:
	if !Engine.is_editor_hint():
		assert(entity != null)
		collision_layer = 0
		collision_mask = 0
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		add_to_group(Groups.CUSTOM_COLLISION_OBJECT)
		var nodes: Array[Node] = find_children("*", "CollisionShape3D", true, true)
		for node in nodes:
			shapes.append(node)
		if shapes.size() > 1:
			push_warning("CArea3D with more than 1 CollisionShape3D at %s" % [str(self)])
		
func hit(data: CollisionData) -> void:
	entity.raise_local(CollisionEntityEvent.new(self, data))

func cset_collision_mask_value(value: int, on: bool) -> void:
	if collision_mask == 0 and on:
		set_deferred("monitoring", true)
	set_collision_mask_value(value, on)
	if collision_mask == 0:
		set_deferred("monitoring", false)

func cset_collision_layer_value(value: int, on: bool) -> void:
	if collision_layer == 0 and on:
		set_deferred("monitorable", true)
	set_collision_layer_value(value, on)
	if collision_layer == 0:
		set_deferred("monitorable", false)
