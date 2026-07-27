@tool
extends Node3D

@export var chunk_scene_path: String = "res://terrain_chunk.tscn" # Path to your chunk scene
@export var grid_size: int = 4
@export var chunk_size: int = 64

# Shared Noise Resources (Ensures seamless borders)
var b_noise = FastNoiseLite.new()
var m_noise = FastNoiseLite.new()
var cell_noise = FastNoiseLite.new()

func _ready():
	_setup_noises()
	generate_grid()

func _setup_noises():
	# Biome Noise (Large scale)
	b_noise.seed = randi()
	b_noise.frequency = 0.01
	
	# Plains Detail Noise
	m_noise.seed = b_noise.seed + 1
	m_noise.frequency = 0.05
	
	# Cellular Noise for Mountains
	cell_noise.seed = b_noise.seed + 2
	cell_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	cell_noise.frequency = 0.08 # Tighter tiers
	cell_noise.cellular_return_type = FastNoiseLite.CellularReturnType.RETURN_CELL_VALUE

func generate_grid():
	# Clear existing chunks if any
	for child in get_children():
		child.queue_free()
		
	for x in range(grid_size):
		for y in range(grid_size):
			var chunk = OldChunk.new()
			add_child(chunk)
			
			# Position the chunk in the world
			chunk.position = Vector3(x * chunk_size, 0, y * chunk_size)
			
			# Initialize with coordinates and shared noises
			# Note: Ensure your chunk script has this exact signature!
			chunk.init_chunk(Vector2i(x, y), chunk_size, b_noise, m_noise, cell_noise)
