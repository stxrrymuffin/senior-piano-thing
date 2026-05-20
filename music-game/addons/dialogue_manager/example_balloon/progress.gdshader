shader_type canvas_item;

uniform float speed = 3;
uniform float amplitude = 4.0;

void vertex() {
	VERTEX.y += sin(TIME * speed) * amplitude;
}