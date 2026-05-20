shader_type canvas_item;

uniform float speed = 2.0;
uniform float amplitude = 50.0;

void vertex() {
	VERTEX.y += sin(TIME * speed) * amplitude;
}