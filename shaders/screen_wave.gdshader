shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float speed_mult_x = 0.5;
uniform float strength_x = 1;
uniform float wave_length_x = 10;
uniform float speed_mult_y = 0.5;
uniform float strength_y = 1;
uniform float wave_length_y = 10;

varying vec4 vertex_color; 

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 adjusted_uv = SCREEN_UV;
	adjusted_uv.x *= aspect; 
	float offset_y = sin(adjusted_uv.x * wave_length_y + TIME * speed_mult_y) * (strength_y / 16.0);
	float offset_x = sin(adjusted_uv.y * wave_length_x + TIME * speed_mult_x) * (strength_x / 16.0);
	COLOR = textureLod(screen_texture, SCREEN_UV + vec2(offset_x, offset_y), 0.0);
	COLOR.a = vertex_color.a;
}