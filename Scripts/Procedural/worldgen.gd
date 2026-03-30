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
		  -1.0: -40,    # deep ocean
		  -0.5: -22,    # shallow ocean
		   0.0: 0,      # sea-level baseline / flat land
		   0.5: 40,     # highlands
		   1.0: 120     # tallest continental peaks
		},
		"weight": 1.0    # full influence on macro terrain
	},
	"erosion": {
		"values": {
			-1.0: -30,
			-0.5: -10,
			 0.0: 0,
			 0.5: 10,
			 1.0: 25
		},
		"weight": 1.0
	},
	"height": {
		"values": {
			-1.0: -20,
			-0.5: -5,
			 0.0: 0,
			 0.5: 20,
			 1.0: 60
		},
		"weight": 1.0
	}
}

# Biome definitions based on climate ranges
# temperature and humidity values are expected in [-1,1]
var biomes = {
	#"desert": {
		#"temp_min": 0.4,
		#"temp_max": 1.0,
		#"humid_min": -1.0,
		#"humid_max": -0.1,
		#"height_mult": 0.3,
		#"roughness": 0.2
	#}
	#,
	"plains": {
		"temp_min": -1,
		"temp_max": 1,
		"humid_min": -1,
		"humid_max": 1,
		"height_mult": 0.5,
		"roughness": 0.4
	}
	#,
	#"forest": {
		#"temp_min": -0.1,
		#"temp_max": 0.6,
		#"humid_min": 0.3,
		#"humid_max": 1.0,
		#"height_mult": 0.6,
		#"roughness": 0.5
	#}
	#,
	#"snow": {
		#"temp_min": -1.0,
		#"temp_max": -0.3,
		#"humid_min": -1.0,
		#"humid_max": 1.0,
		#"height_mult": 0.6,
		#"roughness": 0.4
	#}
	#,
	#"mountains": {
		#"temp_min": -1.0,
		#"temp_max": 1.0,
		#"humid_min": -1.0,
		#"humid_max": 1.0,
		#"height_mult": 1.8,
		#"roughness": 1.0
	#}
}

var terrace_settings: Dictionary = \
{
	"base_step_height": 2.0,
	"max_step_multiple": 7,
	"mountain_start_height": 18.0,
	"mountain_full_height": 110.0,
	"control_noise_scale": 0.012
}

func _ready():
	if not Engine.is_editor_hint():
		generate_world()

func generate_world():

	for child in get_children():
		if child is TerrainChunk:
			child.queue_free()

	chunks.clear()

	for x in range(-render_distance, render_distance):
		for y in range(-render_distance, render_distance):
			create_chunk(Vector2i(x,y))


func create_chunk(c_pos: Vector2i):

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
