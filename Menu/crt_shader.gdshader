shader_type canvas_item;
render_mode blend_mul;

uniform float scanline_count : hint_range(0, 2048) = 700.0;
uniform float scanline_brightness : hint_range(0, 1.0) = 0.25;
uniform float vignette_strength : hint_range(0, 1.0) = 0.45;
uniform float noise_strength : hint_range(0, 0.5) = 0.05;
uniform float mask_strength : hint_range(0, 1.0) = 0.2;
uniform float brightness : hint_range(0.5, 2.0) = 1.2;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// Thin, frequent scanlines
	float scanline = sin(UV.y * scanline_count * PI) * 0.5 + 0.5;
	scanline = pow(scanline, 1.6);
	float scan_factor = mix(1.0 - scanline_brightness, 1.0, scanline);

	// Vertical shadow mask artifacts
	float mask = sin(UV.x * 400.0) * 0.5 + 0.5;
	mask = pow(mask, 5.0);
	float mask_factor = mix(1.0 - mask_strength, 1.0, mask);

	// Vignette - darker corners
	float d = length(UV - 0.5) * 1.41421356;
	float vignette_factor = 1.0 - smoothstep(0.2, 1.0, d) * vignette_strength;

	// Temporal noise with brightness pulse
	float pulse = 0.95 + sin(TIME * 2.0) * 0.05;
	float noise = rand(UV + TIME * 3.0) * noise_strength;

	COLOR.rgb = vec3(scan_factor * mask_factor * vignette_factor * pulse + noise) * brightness;
	COLOR.a = 1.0;
}
