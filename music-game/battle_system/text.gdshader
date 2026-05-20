shader_type canvas_item;

uniform float speed = 1.5;
uniform float amplitude = 6.0;

void vertex() {
	VERTEX.y += sin(TIME * speed) * amplitude;
}