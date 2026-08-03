shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled, unshaded;

uniform sampler2D noise_tex : repeat_enable;
uniform sampler2D edge_gradient_tex : hint_default_white;

uniform vec4 laser_color : source_color = vec4(0.2, 0.8, 1.0, 1.0);
uniform float laser_intensity : hint_range(1.0, 20.0) = 10.0;
uniform float scroll_speed : hint_range(-15.0, 15.0) = 6.0;
uniform float draw_progress : hint_range(0.0, 1.0) = 0.0;
uniform float spin_speed : hint_range(-15.0, 15.0) = 0.0;

void fragment() {
    // Convert horizontal UV into a 3D angle (radians)
    float angle = UV.x * TAU + (TIME * spin_speed);
    
    // Create 2D coordinates on a circle instead of flat UV.x
    vec2 polar_uv = vec2(cos(angle), sin(angle)) * 0.5 + 0.5;
    
    // Combine polar X/Z rotation with scrolling Y height
    vec2 scrolling_uv = vec2(UV.x * 3.0 + (TIME * spin_speed), UV.y * 3.0 + (TIME * scroll_speed));
   
    //float noise_val = texture(noise_tex, scrolling_uv).r;
	float noise_val = textureLod(noise_tex, scrolling_uv, 0.0).r;
    
	float fresnel = 1.0 - abs(dot(NORMAL, VIEW));
    // 3. Cylinder edge falloff (Bright center core, soft edges)
    float beam_edge = sin(UV.x * PI); 
    float core_glow = pow(beam_edge, 2.5);
	
	float front_fill = pow(1.0 - fresnel, 3.0) * 0.75;
	float glow = max(core_glow, front_fill);
	
	float vertical_fade = texture(edge_gradient_tex, vec2(1, UV.y)).r;
	vertical_fade = pow(vertical_fade, 3);
    
    // Combine noise texture with edge falloff
    float final_alpha = glow* noise_val * draw_progress * vertical_fade;
    
    ALBEDO = laser_color.rgb;
    ALPHA = final_alpha * laser_color.a;
    EMISSION = laser_color.rgb * laser_intensity * final_alpha;
}