shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float speed_mult = 0.5;

void fragment() {
	vec2 S_UV = SCREEN_UV;
	float noise = fract(sin(dot(vec2(S_UV.x), vec2(12.9898, 78.233))) * 43758.5453);
	
	S_UV.y = fract(S_UV.y - TIME * speed_mult * noise);
	
	COLOR.rgb = textureLod(screen_texture, S_UV, 0.0).rgb;
}
