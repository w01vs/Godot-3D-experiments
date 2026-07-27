@tool
extends Node3D

@export_group("Dimensions")
@export var n : int = 100
@export var m : int = 100

@export_group("Generation Settings")
@export var region_count : int = 5 # How many "Clusters" of hills or lakes
@export var bumps_per_region : int = 15
@export var base_step_height : float = 0.6

@export var trigger_generate: bool = false:
	set(val):
		if val: generate_world()

var height_map : Array = []

func generate_world():
	_initialize_map()
	
	# 1. Generate Regions
	for i in range(region_count):
		# Decide if this region is a Highland (Mountain) or Lowland (Lake)
		var is_lake = randf() < 0.3 # 30% chance for a lake region
		_generate_region(is_lake)
	
	_render_mesh()

func _initialize_map():
	height_map = []
	for x in range(n):
		var row = []
		for y in range(m):
			row.append(0.0)
		height_map.append(row)

func _generate_region(is_lake: bool):
	# Pick a center for the region
	var cx = randi_range(10, n - 11)
	var cy = randi_range(10, m - 11)
	
	# Adjust properties based on region type
	var multiplier = -1.0 if is_lake else 1.0
	var region_radius = randf_range(15.0, 30.0)
	
	for i in range(bumps_per_region):
		# Jitter the bumps around the region center
		var bx = cx + randi_range(-int(region_radius/2), int(region_radius/2))
		var by = cy + randi_range(-int(region_radius/2), int(region_radius/2))
		
		# Clamp jittered coordinates
		bx = clampi(bx, 0, n - 1)
		by = clampi(by, 0, m - 1)
		
		# Randomize bump size and height per bump
		var radius = randf_range(5.0, 15.0)
		var step = base_step_height * randf_range(0.8, 2.0) * multiplier
		
		_add_custom_bump(bx, by, radius, step)

func _add_custom_bump(tx: int, ty: int, s: float, step: float):
	var tz : float = height_map[tx][ty]
	var target_vec = Vector3(tx, tz, ty)
	var margin = int(s) + 1
	
	for i in range(max(0, tx - margin), min(n, tx + margin)):
		for j in range(max(0, ty - margin), min(m, ty + margin)):
			var current_vec = Vector3(i, height_map[i][j], j)
			var d = current_vec.distance_to(target_vec)
			
			if d < s:
				var influence = 1.0 - (d / s)
				# 0.4 threshold keeps the cliffs steep
				if influence > 0.4: 
					height_map[i][j] += step

# --- RENDER LOGIC (Keeping your SurfaceTool setup) ---

func _render_mesh():
	for child in get_children():
		if child is MeshInstance3D:
			child.queue_free()

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1) 

	var mat = StandardMaterial3D.new()
	# Optional: Make the material look more like stone/dirt
	mat.albedo_color = Color(0.5, 0.5, 0.5)
	st.set_material(mat)

	for x in range(n - 1):
		for y in range(m - 1):
			var v1 = Vector3(x, height_map[x][y], y)
			var v2 = Vector3(x, height_map[x][y + 1], y + 1)
			var v3 = Vector3(x + 1, height_map[x + 1][y], y)
			var v4 = Vector3(x + 1, height_map[x + 1][y + 1], y + 1)

			st.add_vertex(v1); st.add_vertex(v3); st.add_vertex(v2)
			st.add_vertex(v2); st.add_vertex(v3); st.add_vertex(v4)

	st.generate_normals()
	st.index()
	var mesh = st.commit()

	var mi = MeshInstance3D.new()
	mi.mesh = mesh
	add_child(mi)
	call_deferred("_setup_collision", mi)

func _setup_collision(mi: MeshInstance3D):
	if not mi or not mi.mesh: return
	var sb = StaticBody3D.new()
	mi.add_child(sb)
	var cs = CollisionShape3D.new()
	cs.shape = mi.mesh.create_trimesh_shape()
	sb.add_child(cs)
	if Engine.is_editor_hint():
		var root = get_tree().edited_scene_root
		if root:
			mi.owner = root; sb.owner = root; cs.owner = root
