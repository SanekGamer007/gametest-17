shader_type canvas_item;
uniform float threshold = 0.5;
uniform vec3 replace_color : source_color = vec3(1.0);

void fragment() {
	float gray = 0.33 * (COLOR.r + COLOR.g + COLOR.b); // Thanks to the internet!
	COLOR.rgb = vec3(mix(0.0, 1.0, step(clamp(cos(sin(threshold * TIME) * 1.2), threshold, 0.8), gray))); // Thanks to the internet!
	if (COLOR.rgb == vec3(0.0)) {
		COLOR.a = 0.0;
	} else {
		COLOR.rgb = replace_color;
	};
}
