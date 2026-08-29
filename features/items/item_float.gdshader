shader_type spatial;
render_mode blend_add, depth_draw_never, unshaded, cull_back;

// --- Uniforms ---
uniform vec4 outline_color : source_color = vec4(1.0, 0.9, 0.0, 1.0);
uniform float fresnel_power : hint_range(0.1, 10.0) = 3.0;
uniform float core_transparency : hint_range(0.0, 1.0) = 0.1;
uniform float rim_smoothness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	// 1. Get the dot product between the surface normal and the camera view direction.
	// In Godot 4, 'NORMAL' is already in View Space.
	// We need 'VIEW', which is from the vertex to the camera.
	// Since we are using View Space, VIEW = normalize(-VERTEX);
	vec3 view_dir = normalize(-VERTEX);
	float n_dot_v = dot(NORMAL, view_dir);
	
	// 2. Calculate the Fresnel effect (0 at center, 1 at edges)
	float fresnel = 1.0 - n_dot_v;
	
	// 3. Apply power for sharpness (classic smoothstep Fresnel)
	fresnel = pow(fresnel, fresnel_power);
	
	// 4. Create the final alpha mask: Core is mostly clear, edge is bright
	// Use smoothstep for soft rim blending
	float alpha_mask = smoothstep(core_transparency, core_transparency + rim_smoothness, fresnel);
	
	ALBEDO = outline_color.rgb;
	ALPHA = alpha_mask * outline_color.a;
}