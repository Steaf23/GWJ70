shader_type canvas_item;

uniform bool enable = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (enable) {
		color.rgb = vec3(1, 1, 1);
	}
	COLOR = color;
	// Called for every pixel the material is visible on.
}
