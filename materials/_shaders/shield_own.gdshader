// https://godotshaders.com/shader/energy-shield-with-impact-effect/

shader_type spatial;
render_mode shadows_disabled, specular_disabled, ambient_light_disabled, unshaded;


group_uniforms Shield_Color;
uniform vec3 _shield_color : source_color = vec3(0.0, 0.0, 1.0);
uniform vec3 _shield_color_1 : source_color = vec3(1.0, 1.0, 1.0);
uniform float _shield_color_brightness : hint_range(0.25, 20.0, 0.05) = 10.0;
uniform float _shield_intensity : hint_range(0.25, 5.0, 0.05) = 2.0;

group_uniforms Shield_Transform;
uniform float _shield_size : hint_range(0.0, 0.5, 0.01) = 0.0;
uniform vec3 shield_displace = vec3(0.3, 0.1, 0.1);

group_uniforms Flash;
uniform vec3 _flash_global_position;
uniform float _effect_max_distance : hint_range(0.0, 10.0, 0.1) = 4.0;


varying float distances_to_flash;

// === SHIELD ===
float saturate(float x) {
  return max(0, min(1, x));
}

vec3 direction(vec3 from, vec3 to) {
    return normalize(to - from);
}

float ComputeFresnel(vec3 norm, vec3 view_dir, float intensity) {
	// dot product between mesh normals and view direction
	float fresnel = saturate(1.0 - dot(norm, view_dir));
	// modulate fresnel intensity
	fresnel = pow(fresnel, intensity);
	return fresnel;
}

void vertex() {
	float displacement = 0.0;
	// Calculate the vertex position in world space
	vec3 vertex_world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Calculate distance to flash
	float vertex_distance_to_flash = distance(vertex_world_position, _flash_global_position);
	float vertex_distance_to_flash_clamped = clamp(vertex_distance_to_flash / _effect_max_distance, 0.0, 1.0);
	distances_to_flash = vertex_distance_to_flash;
	vec3 vertex_direction_to_flash = direction(vertex_world_position, _flash_global_position);
	float vertex_dot_to_flash = min(0.0, dot(NORMAL * -1.0, vertex_direction_to_flash));
	
	displacement += (smoothstep(shield_displace.x, shield_displace.y, vertex_distance_to_flash_clamped) * shield_displace.z) * vertex_dot_to_flash;
	

	VERTEX += NORMAL * (displacement + _shield_size);
}

void fragment() {
    // Add fresnel
	float fresnel = ComputeFresnel(NORMAL, VIEW, _shield_intensity);

	vec3 color_blend = mix(vec3(_shield_color_1.r * 1.5, _shield_color_1.g * 1.5, _shield_color_1.b * 1.0), _shield_color, clamp(distances_to_flash, 0.0, 1.0));
	
	float inverse_distance = 1.0 - clamp(distances_to_flash / _effect_max_distance, 0.0, 1.0);
	
	// set color and alpha
	ALBEDO = mix(color_blend, color_blend * _shield_color_brightness, inverse_distance);
	ALPHA *= fresnel * max(0.1, inverse_distance);
}