@tool
extends TextureRect

@export_group("Dimensions")
@export var width: int = 512
@export var height: int = 512

@export_group("Rivers")
@export var river_zoom: float = 1.0:
	set(v):
		river_zoom = v
		_generate()

@export var river_width_smooth: float = 0.0:
	set(v):
		river_width_smooth = v
		_generate()

@export var river_mask: float = 0.0:
	set(v):
		river_mask = v
		_generate()

@export var river_min_height: float = 0.0:
	set(v):
		river_min_height = v
		_generate()

@export var river_max_height: float = 0.0:
	set(v):
		river_max_height = v
		_generate()

@export var noise_river: FastNoiseLite = FastNoiseLite.new():
	set(v):
		noise_river = v
		if noise_river and not noise_river.changed.is_connected(_generate):
			noise_river.changed.connect(_generate)
		_generate()

@export_group("Terrain")
@export var zoom: float = 1.0:
	set(v):
		zoom = v
		_generate()

@export var noise: FastNoiseLite = FastNoiseLite.new():
	set(v):
		noise = v
		if noise and not noise.changed.is_connected(_generate):
			noise.changed.connect(_generate)
		_generate()

@export var curve: Curve:
	set(v):
		curve = v
		if curve and not curve.changed.is_connected(_generate):
			curve.changed.connect(_generate)
		_generate()

var _internal_tex: ImageTexture
func _ready():
	#_generate()
	pass

func get_spline_height(n: float) -> float:
		return curve.sample(n)

func get_color_from_height(h: float) -> Color:
	if h < -20:   return Color(0.085, 0.0, 0.443, 1.0) # deep ocean
	elif h < 0: return Color(0.46, 0.755, 0.971, 1.0) # ocean
	elif h < 20: return Color(0.418, 0.644, 0.208, 1.0) # normal
	elif h < 50: return Color(0.508, 0.385, 0.191, 1.0) # hill?
	#elif h < 60: return Color(0.70, 0.70, 0.70) # Tier 5
	else: return Color(0.84, 0.84, 0.84) # Tier 6

func _generate():
	var image = Image.create(width, height, false, Image.FORMAT_RGB8)
	
	for y in range(height):
		for x in range(width):
			var s_x = x * zoom
			var s_y = y * zoom
			var n = noise.get_noise_2d(s_x, s_y)
			var h = get_spline_height(n)
			
			var is_river = false
			
			if noise_river:
				# 1. Calculate the 'vein' mask
				var r_val = noise_river.get_noise_2d(x * river_zoom, y * river_zoom)
				var r_mask = 1.0 - smoothstep(0.0, river_width_smooth, abs(r_val))
				
				# 2. Rule: Only allow rivers on 'Land' (above sea level but below high peaks)
				# Adjust 2.0 and 70.0 based on your specific spline/color thresholds
				if h > river_min_height and h < river_max_height:
					if r_mask > river_mask:
						is_river = true
			
			# 3. Final Pixel Choice
			if is_river:
				image.set_pixel(x, y, Color(0.46, 0.75, 0.97))
			else:
				image.set_pixel(x, y, get_color_from_height(h))

	_internal_tex = ImageTexture.create_from_image(image)
	queue_redraw()

func _draw():
	if _internal_tex:
		draw_texture_rect(_internal_tex, Rect2(Vector2.ZERO, size), false)
