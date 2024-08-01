shader_type spatial;
 render_mode depth_prepass_alpha, cull_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;

uniform vec4 emission_color : source_color = vec4(1);
uniform float emission_amount;

uniform sampler2D dissolve_texture;
uniform float burn_size : hint_range(0, 2);
uniform float dissolve_amount : hint_range(0, 1);

uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001);
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset;

varying vec3 uv1_power_normal;
varying vec3 uv1_triplanar_pos;

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void vertex() {
	vec3 normal = NORMAL;

	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);

	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);

	// UV1 Triplanar: Enabled
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo, uv1_power_normal, uv1_triplanar_pos);
	// vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	float sample = texture(dissolve_texture, UV).r;
	float emission_value = 1.0 - smoothstep(dissolve_amount, dissolve_amount + burn_size, sample);
	EMISSION = vec3(emission_value * emission_amount * emission_color.rgb);
	float alpha = smoothstep(dissolve_amount - burn_size, dissolve_amount, sample);
	if(alpha <= 0.01){
		discard;
	}
}