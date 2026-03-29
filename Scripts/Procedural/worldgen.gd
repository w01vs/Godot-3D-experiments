@tool
extends Node3D

@export var color: StandardMaterial3D
@export_group("Generation Settings")
@export var chunk_size: int = 64
@export var render_distance: int = 4


@export_group("Biome Balances")
@export var mountain_threshold: float = 0.15
@export var lake_threshold: float = -0.2
@export var plateau_levels: int = 4

@export_group("Verticality")
@export var mountain_step_height: float = 5.0
@export var lake_step_depth: float = -2.5
@export var plains_variation_amount: float = 0.2

@export_group("Noise Sources")
@export var biome_noise: FastNoiseLite
@export var plains_noise: FastNoiseLite
@export var plateau_noise: FastNoiseLite

var chunks: Dictionary[Vector2i, TerrainChunk] = {}

func _ready():
	generate_world()
	
func generate_random_world() -> void:
	biome_noise.seed = randi()
	plains_noise.seed = randi()
	plateau_noise.seed = randi()
	generate_world()
	biome_noise.seed = 0
	plains_noise.seed = 1
	plateau_noise.seed = 2
	
func generate_world():
	# Clear existing
	for child in get_children():
		child.queue_free()
	chunks.clear()
	
	for x in range(-render_distance, render_distance):
		for y in range(-render_distance, render_distance):
			create_chunk(Vector2i(x, y))

func create_chunk(c_pos: Vector2i):
	var chunk = TerrainChunk.new() # Your C++ Class
	add_child(chunk)
	chunk.position = Vector3(c_pos.x * chunk_size, 0, c_pos.y * chunk_size)
	# 1. Push the Inspector settings to the C++ instance
	chunk.mountain_threshold = mountain_threshold
	chunk.lake_threshold = lake_threshold
	chunk.plateau_levels = plateau_levels
	chunk.mountain_height_step = mountain_step_height
	chunk.lake_depth_step = lake_step_depth
	chunk.plains_variation = plains_variation_amount
	chunk.set_material(color)
	
	# 2. Run the C++ generation logic
	chunk.generate_chunk(c_pos, chunk_size, biome_noise, plains_noise, plateau_noise)
	
	chunks[c_pos] = chunk
	
	
	
	
	
