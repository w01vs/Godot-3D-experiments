extends RayCast3D

var current_collider: CollisionObject3D

signal ui_switched(state: GlobalRefs.PlayerState)

@onready var player: Node3D = $"../../../.."

var build_scene: PackedScene = load("res://Scenes/build_box.tscn")

var buildx: MeshInstance3D = null

var state : GlobalRefs.PlayerState = GlobalRefs.PlayerState.DEFAULT

var snapping: bool = false

var last_buildx_pos: Vector3

func _process(_delta: float) -> void:
	match state:
		GlobalRefs.PlayerState.DEFAULT:
			collision()
		GlobalRefs.PlayerState.BUILD:
			pass

func collision() -> void:
	var collider = get_collider()
	if is_colliding() and collider.has_meta("interactable"):
		if current_collider != collider:
			current_collider = collider
		
		if(Input.is_action_just_pressed("interact")):
			collider.get_meta("interactable").interact(player)
	elif current_collider:
		current_collider = null


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("build"):
		match state:
			GlobalRefs.PlayerState.DEFAULT: 
				state = GlobalRefs.PlayerState.BUILD
				ui_switched.emit(state)
				target_position.y = -15
				set_collision_mask_value(2, false)
				set_collision_mask_value(1, true)
				set_collision_mask_value(5, true)
				buildx = build_scene.instantiate()
				GlobalRefs.world.add_child(buildx)
				if is_colliding():
					buildx.visible = true
					buildx.global_position = get_collision_point()
					buildx.global_position = Vector3(buildx.global_position.x, buildx.global_position.y + buildx.scale.y / 2, buildx.global_position.z)
					buildx.to_holo()
				else:
					buildx.visible = false
					
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
				target_position.y = -5
				
	match state:
		GlobalRefs.PlayerState.BUILD:
			if is_colliding():
				var hit_object = get_collider()
				var hit_point = get_collision_point()
				var hit_normal = get_collision_normal()
				var target_pos: Vector3 = Vector3.ZERO
				# 1. Determine target position
				if snapping and hit_object is BuildBox:
					# Snap directly adjacent to the hit box along its face normal
					target_pos = hit_object.global_position + (hit_normal * buildx.scale)
				else:
					# Free placement: offset away from wall/floor face by half size
					target_pos = hit_point + (hit_normal * (buildx.scale / 2.0))
				
				# 2. Check if the preview moved to a NEW position
				if target_pos != last_buildx_pos:
					buildx.global_position = target_pos
					last_buildx_pos = target_pos
					# Run instant placement validity & material color update
					buildx.body.place_check()
					
				buildx.visible = true
				
				# 3. Handle placement input
				if Input.is_action_just_pressed("default_attack"):
					if buildx.body.placeable:
						buildx.place()
						buildx = build_scene.instantiate()
						GlobalRefs.world.add_child(buildx)
						buildx.to_holo()
						last_buildx_pos = Vector3.INF # Force position update on new instance
			else:
				buildx.visible = false
				
			if Input.is_action_just_pressed("snap"):
				snapping = !snapping
