extends Node3D

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
func _input(event):
	if event is InputEventMIDI:
		if event.channel == 0:
			print("pitch", event.pitch)
