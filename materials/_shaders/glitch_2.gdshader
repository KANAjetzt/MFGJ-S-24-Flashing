// https://github.com/mrdoob/three.js/blob/cd0ff25e3c3938ec82500047ccb43500d242505c/examples/jsm/shaders/DigitalGlitch.js#L4


shader_type canvas_item;

uniform sampler2D texture_base;
uniform sampler2D displacement_texture: repeat_enable;

// Flag to determine if the glitch effect should be applied
uniform bool apply_glitch;

// Glitch parameters
uniform float color_shift_amount : hint_range(-0.5, 0.5, 0.001);
uniform float glitch_angle : hint_range(-3.14, 3.14, 0.01);
uniform float glitch_amount : hint_range(-1.0, 1.0, 0.01);
uniform float glitch_x : hint_range(-1.0, 1.0, 0.01);
uniform float glitch_y : hint_range(-1.0, 1.0, 0.01);

// Color Modulate
uniform vec4 color_modulate : source_color = vec4(1.0);

// Function to generate pseudo-random numbers
float random(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 pixel_color;

    if (apply_glitch) {
        vec2 uv = UV;

        // Calculate coordinates for noise texture with scrolling effect
        vec2 noise_offset = vec2(0.0, TIME * 5.5);
        vec2 noise_coords = uv + noise_offset;

        // Sample the displacement texture with a time-dependent offset
        float displacement = texture(displacement_texture, uv + vec2(sin(2.0) * 12.0, 0.0) * (TIME * 1.0)).r;

        // Apply displacement and RGB shift based on glitch parameters
        uv.x += displacement * glitch_x * (glitch_amount / 5.0);
        uv.y += displacement * glitch_y * (glitch_amount / 5.0);

        vec2 offset = color_shift_amount * vec2(cos(glitch_angle), sin(glitch_angle));
        vec4 color_right = texture(texture_base, uv + offset);
        vec4 color_green = texture(texture_base, uv);
        vec4 color_left = texture(texture_base, uv - offset);

        pixel_color = vec4(color_right.r, color_green.g, color_left.b, color_green.a);

        pixel_color = pixel_color;
    } else {
        // If glitch effect is not applied, sample the base texture
        pixel_color = texture(texture_base, UV);
    }

    // Discard pixels with low red component
    if (pixel_color.r <= 0.05) {
        discard;
    }

    // Output the final color
    COLOR = pixel_color * color_modulate;
}
