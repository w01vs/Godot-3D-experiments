shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded, depth_test_disabled;

uniform sampler2D noise_tex : repeat_enable;
uniform vec4 core_color : source_color = vec4(0.8, 0.95, 1.0, 1.0); // Bright center
uniform vec4 edge_color : source_color = vec4(0.1, 0.5, 1.0, 1.0);  // Blue outer aura

uniform float cap_radius : hint_range(0.1, 10.0) = 1.0; // Control diameter right here
uniform float intensity : hint_range(1.0, 30.0) = 12.0;
uniform float spin_speed : hint_range(-10.0, 10.0) = 1.5;
uniform float core_size : hint_range(0.1, 0.9) = 0.4; // Size of white hot center

void vertex() {
	// 1. Lock Quad to Camera View & Strip skewed parent scaling
	// This forces a perfectly square billboard no matter how long/scaled the parent laser is!
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		vec4(INV_VIEW_MATRIX[0].xyz, 0.0),
		vec4(INV_VIEW_MATRIX[1].xyz, 0.0),
		vec4(INV_VIEW_MATRIX[2].xyz, 0.0),
		MODEL_MATRIX[3]
	);

	// 2. Uniformly scale the billboard by our custom cap_radius variable
	VERTEX.xy *= cap_radius;
}

void fragment() {
	// 1. Convert UV coordinates from (0 to 1) to (-1 to 1) centered at (0,0)
	vec2 centered_uv = UV * 2.0 - 1.0;
	
	// 2. Calculate distance from center (0.0 at center, 1.0 at quad edges)
	float dist = length(centered_uv);
	
	// Prevent edge artifacts
	if (dist > 1.0) {
		discard;
	}
	
	// 3. CIRCLE ALPHA CUTOUT: Smoothly fades to 0.0 at the outer edge of the quad
	float circle_mask = smoothstep(1.0, 0.2, dist);
	
	if (circle_mask <= 0.001) {
		discard;
	}
	
	// 4. ROTATING NOISE: Sample noise using polar-style UV motion
	float angle = atan(centered_uv.y, centered_uv.x);
	vec2 polar_uv = vec2(angle / (2.0 * PI) + 0.5, dist);
	vec2 animated_uv = polar_uv + vec2(TIME * spin_speed * 0.1, -TIME * 0.5);
	
	float noise_val = textureLod(noise_tex, animated_uv, 0.0).r;
	
	// 5. COLOR BLENDING: Hot inner core -> Outer laser color
	float core_mask = smoothstep(core_size, 0.0, dist);
	vec3 final_color = mix(edge_color.rgb, core_color.rgb, core_mask);
	
	// Combine radial distance, noise, and overall brightness
	float final_alpha = circle_mask * (0.6 + 0.4 * noise_val);
	
	ALBEDO = final_color;
	ALPHA = final_alpha * edge_color.a * COLOR.a;
	EMISSION = final_color * intensity * final_alpha;
}