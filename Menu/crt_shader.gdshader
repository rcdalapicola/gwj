shader_type canvas_item;
render_mode blend_mul;

uniform float scanline_count : hint_range(0, 4096) = 300.0;
uniform float scanline_brightness : hint_range(0, 1.0) = 0.08;
uniform float vignette_strength : hint_range(0, 1.0) = 0.3;
uniform float noise_strength : hint_range(0, 0.5) = 0.02;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float scanline = sin(UV.y * scanline_count) * 0.5 + 0.5;
	float scan_factor = mix(0.5, 1.0, scanline);

	float d = length(UV - 0.5) * 1.41421356;
	float vignette_factor = 1.0 - smoothstep(0.3, 1.0, d) * vignette_strength;

	float noise = rand(UV + TIME * 1.5) * noise_strength;

	COLOR.rgb = vec3(scan_factor * vignette_factor + noise);
	COLOR.a = 1.0;
}
