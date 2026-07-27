@tool
extends Node3D

@export var color: StandardMaterial3D

@export_group("Generation Settings")
@export var chunk_size: int = 64
@export var render_distance: int = 4

@export_group("Noise Sources")

# Terrain shaping
@export var continentalness_noise: FastNoiseLite
@export var erosion_noise: FastNoiseLite
@export var height_noise: FastNoiseLite
@export var terrace_noise: FastNoiseLite

# Climate → biome selection
@export var temperature_noise: FastNoiseLite
@export var humidity_noise: FastNoiseLite

@export var trigger_generate: bool = false:
	set(val):
		if val:
			generate_world()
			trigger_generate = false

var chunks: Dictionary = {}

var terrain_shape = \
{
	"continentalness": {
		"values": {
			-1.0: -60.0,  # Deep Ocean
			-0.2: 0.0,    # Coast
			 0.2: 40.0,   # Lowland Plateau
			 0.5: 100.0,  # Highland Plateau (Huge area is now 100m high)
			 1.0: 160.0   # Extreme Highland base
		},
		"weight": 1.0
	},
	"erosion": {
		"values": {
			-1.0: 60.0,   # Low erosion = Sharp peaks ADDED to the base
			 0.0: 0.0,    # Neutral
			 1.0: -40.0   # High erosion = Carved valleys SUBTRACTED from base
		},
		"weight": 1.0
	},
	"height": {
		"values": {
			-1.0: -15.0,
			 1.0: 15.0
		},
		"weight": 1.0
	}
}

# Biome definitions based on climate ranges
# temperature and humidity values are expected in [-1,1]
var biomes = {
	"frozen_peaks": {
		"temp_min": -1.0, "temp_max": -0.4,
		"humid_min": -1.0, "humid_max": 1.0,
		"height_mult": 2.0, "roughness": 1.2,
		"color": Color(0.9, 0.9, 1.0)
	},
	"tundra": {
		"temp_min": -0.4, "temp_max": 0.0,
		"humid_min": -1.0, "humid_max": 1.0,
		"height_mult": 0.6, "roughness": 0.4,
		"color": Color(0.689, 0.45, 0.28, 1.0)
	},
	"plains": {
		"temp_min": 0.0, "temp_max": 0.5,
		"humid_min": -0.3, "humid_max": 0.3,
		"height_mult": 0.5, "roughness": 0.3,
		"color": Color(0.4, 0.7, 0.2)
	},
	"desert": {
		"temp_min": 0.5, "temp_max": 1.0,
		"humid_min": -1.0, "humid_max": -0.2,
		"height_mult": 0.4, "roughness": 0.2,
		"color": Color(0.9, 0.8, 0.4)
	},
	"jungle": {
		"temp_min": 0.4, "temp_max": 1.0,
		"humid_min": 0.4, "humid_max": 1.0,
		"height_mult": 1.1, "roughness": 0.7,
		"color": Color(0.0, 0.3, 0.0)
	}
}

var terrace_settings: Dictionary = \
{
	"base_step_height": 2.0,
	"max_step_multiple": 5,
	"mountain_start_height": 40.0,
	"mountain_full_height": 120.0,
	"control_noise_scale": 0.05
}

func _ready():
	if not Engine.is_editor_hint():
		generate_world()

func generate_world():

	for child in get_children():
		if child is TerrainChunk:
			child.queue_free()

	chunks.clear()
	var max_height = 0.0
	for x in range(-render_distance, render_distance):
		for y in range(-render_distance, render_distance):
			max_height = max(create_chunk(Vector2i(x,y)), max_height)
	
	print("Max height in all chunks: ", max_height)


func create_chunk(c_pos: Vector2i) -> float:

	var chunk = TerrainChunk.new()
	add_child(chunk)

	chunk.position = Vector3(
		c_pos.x * chunk_size,
		0,
		c_pos.y * chunk_size
	)

	# Push biome dictionary
	chunk.region_settings = biomes

	# Pass noise maps
	chunk.continentalness_noise = continentalness_noise
	chunk.erosion_noise = erosion_noise
	chunk.height_noise = height_noise
	chunk.temperature_noise = temperature_noise
	chunk.humidity_noise = humidity_noise
	chunk.terrace_noise = terrace_noise
	#chunk.debug_chunk_stats = true
	chunk.terrace_settings = terrace_settings

	chunk.generate_chunk(c_pos, chunk_size, terrain_shape)

	chunks[c_pos] = chunk
	
	return chunk.tallest_height


func generate_random_world():

	continentalness_noise.seed = randi()
	erosion_noise.seed = randi()
	height_noise.seed = randi()
	temperature_noise.seed = randi()
	humidity_noise.seed = randi()

	generate_world()
	continentalness_noise.seed = 0
	erosion_noise.seed = 1
	height_noise.seed = 2
	temperature_noise.seed = 3
	humidity_noise.seed = 4
