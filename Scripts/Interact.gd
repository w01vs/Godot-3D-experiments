extends RayCast3D

var current_collider: Interactable

signal ui_switched(state: GlobalRefs.PlayerState)

@onready var player: Node3D = $"../../../.."

var build_scene: PackedScene = load("res://Scenes/build_box.tscn")

var buildx: BuildBox = null

var state : GlobalRefs.PlayerState = GlobalRefs.PlayerState.DEFAULT

var snapping: bool = false

func _process(_delta: float) -> void:
	match state:
		GlobalRefs.PlayerState.DEFAULT:
			collision()
		GlobalRefs.PlayerState.BUILD:
			pass

func collision() -> void:
	var collider = get_collider()
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			current_collider = collider
		
		if(Input.is_action_just_pressed("interact")):
			collider.interact(player)
	elif current_collider:
		current_collider = null


func _physics_process(delta: float) -> void:
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
				if snapping:
					var object = get_collider()
					if object is BuildBox:
						var pt: Vector3 = get_collision_point()
						var loc: Vector3 = object.global_transform
						var offsets: Vector3 = object.scale / 2
						object.area.monitorable = false
						# something something side of the object
						if pt.x > loc.x and pt.y < loc.y + offsets.y and pt.y > loc.y - offsets.y \
						and pt.z < loc.z + offsets.z and pt.z > loc.z - offsets.z:
							buildx.global_position = Vector3(loc.x + offsets.x + buildx.scale.x / 2,
															 loc.y + offsets.y + buildx.scale.y / 2,
															 loc.z + offsets.z + buildx.scale.z / 2)
						elif true:
							pass
							
				else:
					buildx.global_position = get_collision_point()
					buildx.global_position = Vector3(buildx.global_position.x,
													 buildx.global_position.y + buildx.scale.y / 2,
													 buildx.global_position.z)
				buildx.visible = true
				buildx.to_holo()
				if Input.is_action_just_pressed("default_attack"):
					if buildx.placeable:
						buildx.place()
						buildx = build_scene.instantiate()
						GlobalRefs.world.add_child(buildx)
						buildx.to_holo()
			else:
				buildx.visible = false
				
			if snapping:
				pass
			
			
			if Input.is_action_just_pressed("snap"):
				if snapping:
					snapping = false
				else:
					snapping = true
