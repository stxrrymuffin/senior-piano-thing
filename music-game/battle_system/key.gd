extends Sprite2D

@export var pressed: bool : set = set_pressed
@export var color: Color

func set_pressed(value:bool) -> void:
	pressed = value

func _ready():
	pass

func _process(delta:float) -> void:
	if pressed:
		modulate = lerp(modulate, color, 1.0)
		scale.y  = lerp(scale.y, 0.20, 1.0)
		scale.x  = lerp(scale.x, 0.20, 1.0)
	else:
		modulate = lerp(modulate, Color.GRAY, delta * 10.0)
		scale.y  = lerp(scale.y, 0.25, delta * 10.0)
		scale.x  = lerp(scale.x, 0.25, delta * 10.0)
