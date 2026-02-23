shader_type canvas_item;

uniform float corruption_level = 0.0;

void fragment() {
	vec2 uv = UV;
	if (corruption_level > 0.0) {
		// Делим экран на крупные блоки
		vec2 block_uv = floor(uv * 20.0) / 20.0;
		// Генерируем "мусорное" смещение на основе блока
		float noise = fract(sin(dot(block_uv, vec2(12.9898, 78.233))) * 43758.5453);
		if (noise < corruption_level) {
			uv += vec2(noise * 0.1, noise * 0.1); // Сдвигаем текстуру
		}
	}
	COLOR = texture(TEXTURE, uv);
}
