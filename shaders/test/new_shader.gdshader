shader_type canvas_item;

uniform float speed = 1;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	vec3 red = vec3(1.0, 0.0, 0.0);
	vec3 blue = vec3(0.0, 0.0, 1.0);
	vec3 white = vec3(0.5, 0.5, 0.5);
	vec3 gradient = mix(tex.rgb * red, tex.rgb * blue, UV.x);
	
	float dist = distance(UV, vec2(0.5, 0.5));
	float radius = 0.35 + sin(TIME) * 0.15;
	
	float mask = step(dist, radius);
	
	vec3 final = gradient + white * mask;
	
	COLOR = vec4(final, tex.a);
}