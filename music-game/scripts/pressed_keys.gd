extends Node

var pressed_keys = []

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		#print('hey')
		if event.echo:
			return
		if event.pressed:
			if not pressed_keys.has(event.keycode):
				pressed_keys.push_back(event.keycode)
		else:
			if pressed_keys.has(event.keycode):
				pressed_keys.erase(event.keycode)
	if event is InputEventMIDI:
		if not pressed_keys.has(event.pitch):
			pressed_keys.push_back(event.pitch)
		else:
			pressed_keys.erase(event.pitch)
