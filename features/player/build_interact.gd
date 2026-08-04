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
			if is_colliding():
				var hit_object: Node3D = get_collider()
				var hit_point: Vector3 = get_collision_point()
				var hit_normal: Vector3 = get_collision_normal()
				var target_pos: Vector3 = Vector3.ZERO
				structure_comp = buildx.get_component(StructureComponent)
				# 1. Determine target position
				if snapping and hit_object is CArea3D:
					if hit_object.entity.has_component(StructureComponent):
						# Snap directly adjacent to the hit box along its face normal
						target_pos = hit_object.entity.global_position + (hit_normal * buildx.scale)
				else:
					# Free placement: offset away from wall/floor face by half size
					target_pos = hit_point + (hit_normal * (buildx.scale / 2.0))
				
				# 2. Check if the preview moved to a NEW position
				if target_pos != last_buildx_pos:
					structure_comp.moveto(target_pos)
					last_buildx_pos = target_pos
					# Run instant placement validity & material color update
					structure_comp.place_check()
					
				structure_comp.set_visible(true)
				
				# 3. Handle placement input
				if Input.is_action_just_pressed("default_attack"):
					if structure_comp.placeable:
						structure_comp.place()
						buildx = build_box.instantiate()
						GlobalRefs.world.add_child(buildx)
						structure_comp = buildx.get_compoonent(StructureComponent)
						structure_comp.to_holo()
						last_buildx_pos = Vector3.INF # Force position update on new instance
			else:
				structure_comp.set_visible(false)
				
			if Input.is_action_just_pressed("snap"):
				snapping = !snapping
				structure_comp.snapping = snapping
