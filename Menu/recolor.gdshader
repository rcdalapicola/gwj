shader_type canvas_item;

uniform sampler2D crack_mask;
uniform vec2 crack_world_pos;
uniform float mask_size = 128.0;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Convert world position to mask coordinates
	vec2 local = (world_pos - crack_world_pos) / mask_size + vec2(0.5);

	float mask = 0.0;

	// Only sample the mask inside its bounds
	if (local.x >= 0.0 && local.x <= 1.0 &&
		local.y >= 0.0 && local.y <= 1.0) {
		mask = texture(crack_mask, local).r;
	}

	// Very strong blue recolor
	vec3 strong_blue = vec3(0.0, 0.0, 1.0);

	color.rgb = mix(color.rgb, strong_blue, mask);

	COLOR = color;
}