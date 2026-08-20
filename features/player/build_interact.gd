extends RayCast3D

signal ui_switched(state: int)

@export var build_box: PackedScene

var buildx: Node3D
var structure_comp: StructureComponent

var snapping: bool = false

var state: int = 1

var last_buildx_pos: Vector3

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("build"):
		match state:
			GlobalRefs.PlayerState.DEFAULT: 
				state = GlobalRefs.PlayerState.BUILD
				ui_switched.emit(state)
				target_position.y = -20
				set_collision_mask_value(2, false)
				set_collision_mask_value(1, true)
				set_collision_mask_value(5, true)
				buildx = build_box.instantiate()
				GlobalRefs.world.add_child(buildx)
				structure_comp = buildx.get_component(StructureComponent)
				structure_comp.to_holo()
				if is_colliding():
					structure_comp.set_visible(true)
					structure_comp.moveto(Vector3(buildx.global_position.x, buildx.global_position.y + buildx.scale.y / 2, buildx.global_position.z))
				else:
					structure_comp.set_visible(false)
					
				# instance an object and position it at the intersection point of the ray.
			GlobalRefs.PlayerState.BUILD:
				state = GlobalRefs.PlayerState.DEFAULT
				ui_switched.emit(state)
				set_collision_mask_value(2, true)
				set_collision_mask_value(1, false)
				set_collision_mask_value(5, false)
				if buildx:
					buildx.queue_free()
					buildx = null
					structure_comp = null
				target_position.y = -5
				
	match state:
		GlobalRefs.PlayerState.BUILD:
			
