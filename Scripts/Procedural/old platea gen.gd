@tool
extends MeshInstance3D

var height_map = []

func init_chunk(c_pos: Vector2i, size: int, b_noise: FastNoiseLite, m_noise: FastNoiseLite):
	height_map.clear()
	var world_offset = c_pos * size
	
	# 1. Initialize Heightmap with Biome logic
	for x in range(size + 1):
		var row = []
		for y in range(size + 1):
			var gx = world_offset.x + x
			var gy = world_offset.y + y
			
			# Get biome value (-1.0 to 1.0)
			var b_val = b_noise.get_noise_2d(gx, gy)
			var h = 0.0
			
			# BIOME SELECTION
			if b_val > 0.3: # Mountain Biome
				h = _calculate_plateau_stack(gx, gy, b_val, 5.0) 
			elif b_val < -0.2: # Lake Biome
				h = _calculate_plateau_stack(gx, gy, b_val, -3.0)
			else: # Plains
				h = m_noise.get_noise_2d(gx, gy) * 0.2
				
			row.append(h)
		height_map.append(row)
	
	_render_chunk(size)

# This replaces the "AddBump" loop with a pure mathematical check
# It asks: "Is this point part of a plateau based on a secondary noise?"
func _calculate_plateau_stack(gx: float, gy: float, biome_strength: float, height_multi: float) -> float:
	# Use a third noise to create the "Step" shapes
	# Cellular noise is PERFECT for plateaus/cracks
	var cell_noise = FastNoiseLite.new()
	cell_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	cell_noise.frequency = 0.02
	cell_noise.cellular_return_type = FastNoiseLite.CellularReturnType.RETURN_CELL_VALUE
	
	var v = cell_noise.get_noise_2d(gx, gy)
	# Quantize the noise into steps (The "Plateau" look)
	var steps = floor(abs(v) * 6.0) 
	return steps * height_multi * abs(biome_strength)

func _render_chunk(size):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	
	for x in range(size):
		for y in range(size):
			var v1 = Vector3(x, height_map[x][y], y)
			var v2 = Vector3(x, height_map[x][y+1], y+1)
			var v3 = Vector3(x+1, height_map[x+1][y], y)
			var v4 = Vector3(x+1, height_map[x+1][y+1], y+1)
			st.add_vertex(v1); st.add_vertex(v3); st.add_vertex(v2)
			st.add_vertex(v2); st.add_vertex(v3); st.add_vertex(v4)
			
	st.generate_normals()
	self.mesh = st.commit()
	# Add collision logic here...
